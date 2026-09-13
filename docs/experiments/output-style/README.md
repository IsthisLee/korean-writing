# output style 이 답변의 세부를 떨어뜨리는가

이 폴더는 `plugin/output-styles/korean-writing.md` 를 켠 답변이 아무것도 켜지 않은 답변만큼 세부를 담는지 잽니다. 결과와 판단은 [EVALUATION.md](../../../EVALUATION.md) 에 남깁니다.

## 왜 재는가

2026-09-11 에 상시 규칙 주입을 뺐습니다. 문체 규칙을 평소 답변에 넣으니 곁가지 세부가 빠졌기 때문입니다(H13). 규칙을 어휘 수준으로 줄인 판도 같은 곳에서 떨어졌고, 같은 길이의 중립 메모를 넣은 대조군은 떨어지지 않았습니다. 길이가 아니라 문체 규칙 자체가 세부를 깎았다는 뜻입니다.

output style 은 주입보다 개입이 큽니다. 기본 지시에 더하는 것이 아니라 바꾸고, 매 요청에 실립니다. 그래서 싣기 전에 H13 과 같은 시험을 통과해야 합니다.

## 조건

| 조건 | 내용 |
| --- | --- |
| A | 아무것도 켜지 않음. 기준 |
| O | `plugin/output-styles/korean-writing.md` 를 켠 세션 |
| B | 제거된 상시 주입 규칙(`detail-retention/injection/rules/always-on-removed.md`). H13 의 B 와 같은 조건 |
| N | B 와 길이가 비슷한 중립 메모(`.../rules/neutral.md`) |

네 조건의 플래그는 같습니다. 다른 것은 스타일 파일과 주입 훅의 유무뿐입니다.

## 돌리는 법

```bash
docs/experiments/output-style/gen.sh A 1        # 조건 하나, 표본 하나
for c in A O B N; do for s in 1 2 3 4 5 6 7 8; do
  docs/experiments/output-style/gen.sh $c $s
done; done

KW_OUT_BASE=docs/experiments/output-style \
  python3 docs/experiments/detail-retention/injection/judge.py
```

`gen.sh` 는 디바운스 훅을 설명해 달라는 질문(`docs/experiments/always-on/prompts/01.txt`)에 조건별로 답하게 하고 `out/<조건>_<표본>.json` 에 담습니다. 이미 있는 표본은 건너뜁니다. 채점은 H13 이 쓴 채점기를 그대로 씁니다. `KW_OUT_BASE` 로 이 폴더를 가리키면 됩니다.

LLM 을 부르므로 CI 에 넣지 않습니다. 계정 사용량이 떨어지면 답 자리에 안내 문구가 들어오고 채점기가 그 표본을 「답이 아닌 표본」으로 찍습니다.

## 합격선

돌리기 전에 정했습니다. H13 이 쓴 기준과 같습니다.

1. 세부 11항목의 합이 A 와 갈리지 않을 것
2. `delay` 기본값 300ms 를 적은 표본이 0/8 이 아닐 것
3. 설계 질문의 답변 길이가 A 의 85% 이상일 것
4. 블라인드 문체 판정에서 A 에 지지 않을 것

하나라도 떨어지면 스타일을 싣지 않고 결과만 남깁니다. 주입을 뺄 때와 같은 처리입니다.

## 이 측정이 못 보는 것

- 질문 하나에 모델 하나입니다. 과제를 넓히면 달라질 수 있습니다.
- 판정자는 항목이 설명됐는지만 참거짓으로 봅니다. 설명이 얼마나 정확했는지는 보지 않습니다.
- 스타일을 켜는 경로가 실제 배포와 다릅니다. 여기서는 프로젝트의 `.claude/output-styles/` 에 두고 켰습니다. `--plugin-dir` 로 플러그인을 올려 켜는 길은 `--setting-sources` 를 `""`·`project`·`user,project` 로 바꿔 가며 시도했지만 세 번 다 적용되지 않았습니다(2026-09-14). 설치한 사람이 `/config` 에서 이 스타일을 고를 수 있는지는 따로 확인해야 합니다.
