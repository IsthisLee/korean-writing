#!/usr/bin/env bash
# output style 을 켠 답변이 세부를 떨어뜨리는지 재려고 표본을 만든다 (EVALUATION.md H13 과 같은 질문).
#
# 왜 : 2026-09-11 에 상시 주입을 뺀 이유가 세부 손실이었다(H13). output style 은 주입보다 개입이
#      커서 같은 손실이 날 수 있다. 실으려면 같은 시험을 통과해야 한다.
# 무엇: 같은 질문에 조건만 바꿔 답하게 하고 out/<조건>_<표본>.json 에 담는다. 채점은 judge.py 가 한다.
#
# 조건  : A 아무것도 없음(기준)
#         O 이 저장소의 output style 을 켠 세션
#         B 제거된 상시 주입 규칙(H13 의 B, 비교용)
#         N B 와 길이가 비슷한 중립 메모
#
# 사용  : gen.sh <조건> <표본번호>
# 환경  : KW_MODEL 로 생성 모델을 바꾼다(기본 claude-sonnet-5)
#
# 조건마다 플래그를 똑같이 준다. 다른 것은 스타일 파일과 주입 훅의 유무뿐이다.
# --setting-sources project 인 이유는 output style 이 프로젝트의 .claude/output-styles/ 에서 켜지기
# 때문이다. 실행 폴더가 매번 빈 임시 폴더라 A·B·N 이 읽어 들이는 프로젝트 설정은 없다.
# --plugin-dir 로 플러그인을 올려 켜는 길은 세 조합에서 모두 적용되지 않았다(2026-09-14 확인).
set -u
BASE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$BASE/../../.." && pwd)"
RULES="$REPO/docs/experiments/detail-retention/injection/rules"
STYLE="$REPO/plugin/output-styles/korean-writing.md"

[ $# -eq 2 ] || { echo "사용: gen.sh <A|O|B|N> <표본번호>" >&2; exit 2; }
cond=$1; s=$2; model=${KW_MODEL:-claude-sonnet-5}
command -v claude >/dev/null 2>&1 || { echo "claude 가 없다" >&2; exit 2; }

mkdir -p "$BASE/out"
out="$BASE/out/${cond}_${s}.json"
[ -s "$out" ] && exit 0

WORK=$(mktemp -d) || exit 1
cfg="$WORK/settings.json"

case "$cond" in
  A) echo '{}' > "$cfg" ;;
  O) mkdir -p "$WORK/.claude/output-styles"
     cp "$STYLE" "$WORK/.claude/output-styles/korean-writing.md"
     echo '{"outputStyle":"korean-writing"}' > "$cfg" ;;
  B|N) rules="$RULES/always-on-removed.md"; [ "$cond" = N ] && rules="$RULES/neutral.md"
     # 제외 표시는 저장소 검사용이라 주입문에서 뺀다. injection/gen_rule.sh 와 같은 방식이다.
     /usr/bin/python3 - "$rules" "$cfg" <<'PY'
import json, sys
cmd = "sed '/korean-writing: ignore/d' " + json.dumps(sys.argv[1])
json.dump({"hooks": {"SessionStart": [{"matcher": "startup",
          "hooks": [{"type": "command", "command": cmd, "timeout": 10}]}]}},
          open(sys.argv[2], "w"), ensure_ascii=False)
PY
     ;;
  *) echo "모르는 조건: $cond" >&2; exit 2 ;;
esac

if (cd "$WORK" && claude -p "$(cat "$REPO/docs/experiments/always-on/prompts/01.txt")" \
    --no-session-persistence --tools "" --strict-mcp-config --setting-sources project \
    --model "$model" --output-format json --settings "$cfg" < /dev/null) > "$out.tmp" 2> "$out.err"; then
  mv "$out.tmp" "$out"
else
  echo "FAIL $cond $s"
fi
