#!/usr/bin/env bash
# 다른 한국어 도구와 우리 것을 블라인드로 붙인다.
#
# 왜 : 「어느 쪽이 더 나은가」는 기능 목록으로 답할 수 없다. 같은 질문에 두 도구로 답을 만들고
#      어느 쪽이 어느 도구인지 모르는 판정자에게 물어야 한다(EVALUATION.md C7·L).
# 무엇: 갈래 둘을 받아 프롬프트마다 답을 만들고, 순서를 바꿔 두 번 판정해 이긴 쪽을 센다.
#      두 판정이 엇갈리면 무승부다.
#
# 갈래 지정 : none                 아무 지침도 켜지 않는다
#             style:<파일>         그 파일을 output style 로 켠다
#             rewrite:<지침파일>   먼저 지침 없이 초안을 쓰고, 그 지침을 시스템 프롬프트로 붙여 다시 쓴다
#
# 사용  : KW_ARM_A=style:<우리> KW_ARM_B=style:<남의> rival.sh [프롬프트ID...]
#         ID 를 안 주면 01 05 09 11 을 쓴다.
# 환경  : KW_MODEL 생성·판정 모델(기본 claude-sonnet-5), KW_LABEL_A·KW_LABEL_B 결과에 찍을 이름
# 종료  : A 가 진 쌍이 이긴 쌍보다 많으면 1, 아니면 0. 준비물이 없으면 2.
# 비용  : 프롬프트 4개 기준 생성 8~12회와 판정 8회. LLM 을 부르므로 CI 에 넣지 않는다.
#
# blind.sh 와 나눠 둔 이유: 그쪽은 M 절 측정의 재현 장비다. 갈래를 늘리면 그 기록을 흔든다.
set -uo pipefail
BASE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$BASE/../../.." && pwd)"
PROMPTS="$REPO/docs/experiments/always-on/prompts"

ARM_A="${KW_ARM_A:-style:$REPO/plugin/output-styles/korean-writing.md}"
ARM_B="${KW_ARM_B:-none}"
LABEL_A="${KW_LABEL_A:-A}"
LABEL_B="${KW_LABEL_B:-B}"
IDS=("$@"); [ ${#IDS[@]} -gt 0 ] || IDS=(01 05 09 11)
MODEL="${KW_MODEL:-claude-sonnet-5}"
command -v claude >/dev/null 2>&1 || { echo "claude 가 없다" >&2; exit 2; }

WORK=$(mktemp -d) || exit 2
echo "작업 폴더: $WORK"
echo "모델: $MODEL"
echo "갈래 A($LABEL_A): $ARM_A"
echo "갈래 B($LABEL_B): $ARM_B"
echo "프롬프트: ${IDS[*]}"

# 전역 지침은 저장소에 두지 않는다. 사용자 것을 그때그때 읽어 붙인다(regress.sh 와 같다).
SYS="$WORK/sys.txt"
{ echo "이 세션에는 도구와 스킬이 없다. 도구 호출을 흉내 내지 말고 지금 아는 것으로 바로 답한다."
  [ -r "$HOME/.claude/CLAUDE.md" ] && { echo; cat "$HOME/.claude/CLAUDE.md"; }
} > "$SYS"

COMMON=(--no-session-persistence --strict-mcp-config --setting-sources project
        --tools "" --model "$MODEL" --output-format json)

result_of() { /usr/bin/python3 -c "
import json,sys
try: print(json.load(open(sys.argv[1])).get('result') or '')
except Exception: print('')" "$1"; }

# 스타일 파일마다 name 이 다르면 --settings 로 켜기 어렵다. 사본의 name 을 arm 으로 통일한다.
prep_style() { # prep_style <원본> <대상폴더>
  mkdir -p "$2/.claude/output-styles"
  /usr/bin/python3 - "$1" "$2/.claude/output-styles/arm.md" <<'PY'
import re, sys
t = open(sys.argv[1], encoding="utf-8").read()
if t.startswith("---"):
    parts = t.split("---", 2)
    head, rest = parts[1], parts[2]
    if re.search(r"(?m)^name:", head):
        head = re.sub(r"(?m)^name:.*$", "name: arm", head, count=1)
    else:
        head = "\nname: arm" + head
    t = "---" + head + "---" + rest
else:
    t = "---\nname: arm\n---\n\n" + t
open(sys.argv[2], "w", encoding="utf-8").write(t)
PY
  echo '{"outputStyle":"arm"}' > "$2/style.json"
}

gen_arm() { # gen_arm <갈래이름> <스펙> <프롬프트파일> <출력파일>
  local name=$1 spec=$2 q=$3 out=$4 dir file draft
  dir="$WORK/run-$name"; mkdir -p "$dir"
  case "$spec" in
    none)
      (cd "$dir" && claude -p "$(cat "$q")" --append-system-prompt "$(cat "$SYS")" \
          "${COMMON[@]}" < /dev/null) > "$out" 2>/dev/null ;;
    style:*)
      file="${spec#style:}"
      [ -r "$file" ] || { echo "스타일 파일이 없다: $file" >&2; return 1; }
      prep_style "$file" "$dir"
      (cd "$dir" && claude -p "$(cat "$q")" --append-system-prompt "$(cat "$SYS")" \
          "${COMMON[@]}" --settings "$dir/style.json" < /dev/null) > "$out" 2>/dev/null ;;
    rewrite:*)
      file="${spec#rewrite:}"
      [ -r "$file" ] || { echo "지침 파일이 없다: $file" >&2; return 1; }
      # 사후 윤문 도구는 초안이 있어야 일을 한다. 먼저 지침 없이 쓰고 그 글을 고치게 한다.
      (cd "$dir" && claude -p "$(cat "$q")" --append-system-prompt "$(cat "$SYS")" \
          "${COMMON[@]}" < /dev/null) > "$out.draft" 2>/dev/null
      draft=$(result_of "$out.draft")
      [ -n "$draft" ] || { echo "초안이 비었다: $out" >&2; return 1; }
      (cd "$dir" && claude -p "아래 글을 위 지침에 따라 고쳐 써라. 사실과 수치는 그대로 두고 고친 본문만 출력한다.

$draft" --append-system-prompt "$(cat "$file")

$(cat "$SYS")" "${COMMON[@]}" < /dev/null) > "$out" 2>/dev/null ;;
    *) echo "모르는 갈래: $spec" >&2; return 1 ;;
  esac
}

for id in "${IDS[@]}"; do
  p="$PROMPTS/$id.txt"
  [ -r "$p" ] || { echo "프롬프트 없음: $p" >&2; exit 2; }
  gen_arm a "$ARM_A" "$p" "$WORK/${id}_a.json" || exit 2
  gen_arm b "$ARM_B" "$p" "$WORK/${id}_b.json" || exit 2
  echo "  생성 $id"
done

# 생성물이 실제 답변인지 먼저 본다. 이 검사를 건너뛰어 실험을 통째로 버린 적이 있다.
bad=$(/usr/bin/python3 - "$WORK" <<'PY'
import glob, json, os, re, sys
n = 0
for f in glob.glob(os.path.join(sys.argv[1], "*_a.json")) + glob.glob(os.path.join(sys.argv[1], "*_b.json")):
    try:
        t = json.load(open(f)).get("result") or ""
    except Exception:
        n += 1
        continue
    if len(re.findall(r"[가-힣]", t)) < 150 or re.search(r"hit your (weekly|usage) limit|usage limit reached", t):
        n += 1
print(n)
PY
)
[ "$bad" = "0" ] || { echo "무효 생성물 ${bad}건. 판정하지 않는다." >&2; exit 2; }

judge() { # judge <id> <순서 1|2>
  local id=$1 o=$2
  /usr/bin/python3 - "$PROMPTS" "$WORK" "$id" "$o" > "$WORK/j_${id}_$o.txt" <<'PY'
import json, sys
prompts, w, id, o = sys.argv[1:5]
q = open(f"{prompts}/{id}.txt").read()
a = json.load(open(f"{w}/{id}_a.json"))["result"]
b = json.load(open(f"{w}/{id}_b.json"))["result"]
r1, r2 = (a, b) if o == "1" else (b, a)
print(f"""당신은 한국어를 모국어로 쓰는 편집자다. 같은 질문에 대한 두 답변을 읽고, 한국어를 모국어로 쓰는 사람이 직접 쓴 글처럼 더 자연스럽게 읽히는 쪽을 고른다.

- 내용의 옳고 그름과 정보의 양, 길이는 보지 않는다.
- 두 글이 어떤 도구로 쓰였는지 추측하지 않는다. 읽히는 대로 고른다.
- 격식이 높거나 낮은 것 자체는 좋고 나쁨이 아니다.
- 차이를 느끼기 어려우면 tie 를 고른다.

아래 JSON 만 출력한다. 다른 말은 쓰지 않는다.
{{"winner": "1" 또는 "2" 또는 "tie", "why": "한두 문장"}}

=== 질문 ===
{q}

=== 답변 1 ===
{r1}

=== 답변 2 ===
{r2}
""")
PY
  claude -p "$(cat "$WORK/j_${id}_$o.txt")" --no-session-persistence --strict-mcp-config \
    --setting-sources "" --tools "" --model "$MODEL" --output-format json \
    < /dev/null > "$WORK/v_${id}_$o.json" 2>/dev/null
}

win_a=0; win_b=0; tie=0
for id in "${IDS[@]}"; do
  judge "$id" 1; judge "$id" 2
  r=$(/usr/bin/python3 - "$WORK" "$id" <<'PY'
import json, re, sys
w, id = sys.argv[1:3]
def pick(o):
    try:
        t = json.load(open(f"{w}/v_{id}_{o}.json"))["result"]
    except Exception:
        return "tie"
    m = re.search(r'"winner"\s*:\s*"(1|2|tie)"', t)
    if not m or m.group(1) == "tie":
        return "tie"
    v = m.group(1)
    return ({"1": "a", "2": "b"} if o == "1" else {"1": "b", "2": "a"})[v]
x, y = pick("1"), pick("2")
print(x if x == y else "tie")
PY
)
  case "$r" in a) win_a=$((win_a+1));; b) win_b=$((win_b+1));; *) tie=$((tie+1));; esac
  echo "  판정 $id -> $r"
done

echo
echo "$LABEL_A 승 $win_a / $LABEL_B 승 $win_b / 무승부 $tie"
if [ "$win_b" -gt "$win_a" ]; then
  echo "$LABEL_A 가 진 쌍이 더 많다."
  exit 1
fi
echo "$LABEL_A 가 진 쌍이 더 많지는 않다."
exit 0
