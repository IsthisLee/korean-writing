# 도움 받는 곳

무엇을 물어볼지에 따라 가는 곳이 다릅니다. 이슈를 열기 전에 여기서 골라 주세요.

| 상황                                            | 가는 곳                                                                                                        |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| 설치와 사용법을 모르겠다                        | [README](README.md) 의 설치 절부터 봅니다                                                                        |
| 훅이 왜 이 문장을 걸었는지 모르겠다             | [EVALUATION.md](EVALUATION.md) 에 판정 규칙(K 코드)과 각각의 실측 근거가 있습니다                                |
| 훅을 끄고 싶다                                  | `/plugin` 에서 `edit_check` 를 끕니다. 환경변수도 듣습니다([SECURITY.md](SECURITY.md))                          |
| 사람이 쓴 문장을 훅이 잘못 걸었다               | [오탐 이슈](https://github.com/IsthisLee/korean-writing/issues/new?template=awkward-sentence.yml)          |
| 훅이 놓친 AI 티가 있다                          | [규칙 제안 이슈](https://github.com/IsthisLee/korean-writing/issues/new?template=rule.yml)                 |
| 훅이나 스크립트가 죽는다                        | [버그 이슈](https://github.com/IsthisLee/korean-writing/issues/new?template=bug.yml)                       |
| 취약점을 찾았다                                 | 공개 이슈로 올리지 말고 [비공개 신고](https://github.com/IsthisLee/korean-writing/security/advisories/new)  |
| 규칙을 어떻게 잡을지 의논하고 싶다              | [Discussions](https://github.com/IsthisLee/korean-writing/discussions)                                    |
| 고쳐서 보내고 싶다                              | [CONTRIBUTING.md](CONTRIBUTING.md)                                                                               |

## 이슈를 열 때 넣어 주시면 좋은 것

오탐과 버그는 재현이 전부입니다. 걸린 문장을 그대로, `plugin/scripts/check.sh` 의 출력을 그대로 붙여 주세요. 요약하면 어느 규칙이 걸렸는지 저희 쪽에서 다시 찾아야 합니다.

이 저장소는 한 사람이 짬을 내 관리합니다. 답이 며칠 늦을 수 있습니다. 보안 신고만 영업일 기준 5일 안에 접수 여부를 알려 드립니다.
