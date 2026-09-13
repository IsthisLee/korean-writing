#!/usr/bin/env bash
# 정확도·지시 준수 한 건. usage: run_one.sh <id> <cond A|B> <sample> <model>
# A 는 상시 규칙 주입 없음, B 는 있음. 도구를 끄고 추론만 시킨다.
set -u
cd "$(dirname "$0")" || exit 1
id=$1; cond=$2; s=$3; model=$4
REPO="$(cd ../../.. && pwd)"
dir="out/$model"; mkdir -p "$dir"
out="$dir/${id}_${cond}_${s}.json"
[ -s "$out" ] && exit 0

# 주입을 켜는 설정. 저장소의 실제 훅을 그대로 부른다.
cfg="$(mktemp -t kw-settings)" || exit 1
cat > "$cfg" <<JSON
{"hooks":{"SessionStart":[{"matcher":"startup","hooks":[{"type":"command","command":"$REPO/plugin/hooks-handlers/sessionstart.sh","timeout":10}]}]}}
JSON

# 프롬프트는 세 곳에 나뉘어 있다. 정확도·지시 준수는 prompts/, 코드는 prompts-code/, 설계는 prompts-design/.
src=""
for d in prompts prompts-code prompts-design prompts-review prompts-retain prompts-hedge prompts-debug prompts-long; do
  [ -f "$d/$id.txt" ] && { src="$d/$id.txt"; break; }
done
[ -n "$src" ] || { echo "프롬프트가 없다: $id" >&2; exit 1; }

# 빈 디렉터리에서 돌린다. 저장소 안에서 돌리면 모델이 프롬프트 대신 저장소를 뒤진다.
# 실제로 그렇게 오염된 표본이 나왔다(2026-09-11).
NEUTRAL="$(mktemp -d -t kw-neutral)" || exit 1
trap 'rm -f "$cfg"; rm -rf "$NEUTRAL"' EXIT

# O 와 P 는 output style 측정용 쌍이다. O 는 스타일을 켜고 P 는 같은 플래그로 켜지 않는다.
# A·B 와 달리 --setting-sources project 를 쓰는 이유는 스타일이 프로젝트의
# .claude/output-styles/ 에서만 켜졌기 때문이다(2026-09-14 실측). 빈 임시 폴더에서 돌리므로
# P 가 읽어 들이는 프로젝트 설정은 없다. A 와 플래그가 달라 짝을 P 로 따로 둔다.
sources=""
case "$cond" in O|P) sources="project" ;; esac

common=(-p "$(cat "$src")" --no-session-persistence --tools "" --strict-mcp-config --setting-sources "$sources" --model "$model" --output-format json)
extra=()
case "$cond" in
  B) extra=(--settings "$cfg") ;;
  O) mkdir -p "$NEUTRAL/.claude/output-styles"
     cp "$REPO/docs/experiments/output-style/korean-writing.md" "$NEUTRAL/.claude/output-styles/" || exit 1
     echo '{"outputStyle":"korean-writing"}' > "$NEUTRAL/style.json"
     extra=(--settings "$NEUTRAL/style.json") ;;
esac

(cd "$NEUTRAL" && claude "${common[@]}" ${extra[@]+"${extra[@]}"} < /dev/null) > "$out.tmp" 2> "$out.err" && mv "$out.tmp" "$out" || echo "FAIL $id $cond $s $model"
