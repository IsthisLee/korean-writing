#!/usr/bin/env bash
# output style 을 켠 답변과 켜지 않은 답변을 블라인드로 붙인다 (합격선 4번).
#
# 왜 : 세부를 지켜도 문체가 나빠지면 실을 이유가 없다. 문체는 정규식으로 못 재고 블라인드
#      쌍대 판정으로만 잡힌다(EVALUATION.md C7). 표지 개수를 줄인 판이 판정에서 진 적이 있다.
# 무엇: 같은 질문에 두 조건으로 답하게 하고, 어느 쪽이 스타일을 켠 쪽인지 모르는 판정자에게
#      순서를 바꿔 두 번 묻는다. 두 판정이 엇갈리면 무승부로 센다.
#
# 사용  : blind.sh [프롬프트ID...]    ID 를 안 주면 01 05 09 11 을 쓴다
# 환경  : KW_MODEL 생성·판정 모델(기본 claude-sonnet-5)
# 종료  : 스타일을 켠 쪽이 진 쌍이 이긴 쌍보다 많으면 1, 아니면 0. 준비물이 없으면 2.
# 비용  : 프롬프트 4개 기준 생성 8회와 판정 8회. LLM 을 부르므로 CI 에 넣지 않는다.
#
# always-on/regress.sh 를 본떴다. 그쪽은 규칙 파일 둘을 붙이고 여기는 스타일 유무를 붙인다.
# 그 폴더의 gen_one.sh 와 judge_one.sh 는 저장소에 없는 combined-system.txt 를 읽으므로 쓰지 않는다.
# 시스템 프롬프트는 regress.sh 처럼 실행 시점에 만든다.
set -uo pipefail
BASE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$BASE/../../.." && pwd)"
PROMPTS="$REPO/docs/experiments/always-on/prompts"
STYLE="$REPO/docs/experiments/output-style/korean-writing.md"

IDS=("$@"); [ ${#IDS[@]} -gt 0 ] || IDS=(01 05 09 11)
MODEL="${KW_MODEL:-claude-sonnet-5}"
command -v claude >/dev/null 2>&1 || { echo "claude 가 없다" >&2; exit 2; }
[ -r "$STYLE" ] || { echo "스타일 파일이 없다: $STYLE" >&2; exit 2; }

WORK=$(mktemp -d) || exit 2
echo "작업 폴더: $WORK"
echo "모델: $MODEL"
echo "프롬프트: ${IDS[*]}"

# 전역 지침은 저장소에 두지 않는다. 사용자 것을 그때그때 읽어 붙인다(regress.sh 와 같다).
SYS="$WORK/sys.txt"
{ echo "이 세션에는 도구와 스킬이 없다. 도구 호출을 흉내 내지 말고 지금 아는 것으로 바로 답한다."
  [ -r "$HOME/.claude/CLAUDE.md" ] && { echo; cat "$HOME/.claude/CLAUDE.md"; }
} > "$SYS"

# 스타일은 프로젝트의 .claude/output-styles/ 에서 켜진다(2026-09-14 실측).
# --plugin-dir 로 올리는 길은 --setting-sources 를 ""·project·user,project 로 바꿔도 켜지지 않았다.
mkdir -p "$WORK/on/.claude/output-styles" "$WORK/off"
cp "$STYLE" "$WORK/on/.claude/output-styles/korean-writing.md"
echo '{"outputStyle":"korean-writing"}' > "$WORK/style.json"

COMMON=(--no-session-persistence --strict-mcp-config --setting-sources project
        --tools "" --model "$MODEL" --output-format json)

for id in "${IDS[@]}"; do
  p="$PROMPTS/$id.txt"
  [ -r "$p" ] || { echo "프롬프트 없음: $p" >&2; exit 2; }
  (cd "$WORK/off" && claude -p "$(cat "$p")" --append-system-prompt "$(cat "$SYS")" \
      "${COMMON[@]}" < /dev/null) > "$WORK/${id}_off.json" 2>/dev/null
  (cd "$WORK/on" && claude -p "$(cat "$p")" --append-system-prompt "$(cat "$SYS")" \
      "${COMMON[@]}" --settings "$WORK/style.json" < /dev/null) > "$WORK/${id}_on.json" 2>/dev/null
  echo "  생성 $id"
done

# 생성물이 실제 답변인지 먼저 본다. 이 검사를 건너뛰어 실험을 통째로 버린 적이 있다(regress.sh 주석).
bad=$(/usr/bin/python3 - "$WORK" <<'PY'
import glob, json, os, re, sys
n = 0
for f in glob.glob(os.path.join(sys.argv[1], "*_on.json")) + glob.glob(os.path.join(sys.argv[1], "*_off.json")):
    try:
        t = json.load(open(f)).get("result") or ""
    except Exception:
        n += 1
        continue
    if len(re.findall(r"[가-힣]", t)) < 150:
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
a = json.load(open(f"{w}/{id}_off.json"))["result"]
b = json.load(open(f"{w}/{id}_on.json"))["result"]
r1, r2 = (a, b) if o == "1" else (b, a)
print(f"""당신은 한국어 문체 심사자다. 같은 질문에 대한 두 답변 중 어느 쪽이 더 자연스러운 한국어인지 판정한다. 내용의 옳고 그름은 기준이 아니다. 문체만 본다.

감점 패턴: 사물·개념 의인화, 영어 직역 비유, 추상 구조어(축·갈래·결·레이어), 줄표 삽입구, 첫째·둘째 병렬, 목록이 아닌 내용을 불릿으로 쪼갬, 번역투, AI 관용구(결론적으로·요약하면·시사하는 바·혁신적·~할 때다), 문두 접속사 남발, 형식명사 남발, 문장 길이가 다 비슷함, 이모지.

격식이 높거나 낮은 것 자체는 감점이 아니다. 길이도 기준이 아니다.

아래 JSON 만 출력한다.
{{"winner": "1" 또는 "2" 또는 "tie", "why": "한 문장"}}

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

win_on=0; win_off=0; tie=0
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
    if not m:
        return "tie"
    v = m.group(1)
    if v == "tie":
        return "tie"
    return ({"1": "off", "2": "on"} if o == "1" else {"1": "on", "2": "off"})[v]
a, b = pick("1"), pick("2")
print(a if a == b else "tie")
PY
)
  case "$r" in on) win_on=$((win_on+1));; off) win_off=$((win_off+1));; *) tie=$((tie+1));; esac
  echo "  판정 $id -> $r"
done

echo
echo "스타일 켬 승 $win_on / 끔 승 $win_off / 무승부 $tie"
if [ "$win_off" -gt "$win_on" ]; then
  echo "합격선 4번 불합격. 스타일을 켠 쪽이 진 쌍이 더 많다."
  exit 1
fi
echo "합격선 4번 통과. 진 쌍이 더 많지 않다."
exit 0
