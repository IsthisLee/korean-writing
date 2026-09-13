# 한국어 텍스트 개선 정리

## 1. 연구 근거


| 문서                                                                                             | 크기   | 무엇이 있나                                                                                                                                                                                                                                                         |
| ---------------------------------------------------------------------------------------------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [scholarship.md](../plugin/skills/humanize-korean/references/scholarship.md)                   | 35KB | 한국 번역학계의 8대 번역투 계보(무생물 주어, 피동 과다, 대명사 직역, `-들` 기계적 부착, 관계절 직역, 명사화, `-에서의` 류 조사 결합, 종결어미)와 국제 번역학 이론. Baker 1993 번역 보편소, Toury 1995 두 법칙, Laviosa 2002, Chesterman 2004, Toral 2019 post-editese, Sarti 외 2022 DivEMT, Cho 외 2019, Frawley 1984, Hayase 외 2024 |
| [empirical-validation.md](../plugin/skills/humanize-korean/references/empirical-validation.md) | 15KB | 대조 코퍼스로 패턴마다 판별력을 재고 기각한 기록. 사람 글에도 흔한 패턴은 규칙에서 뺐습니다. 모델 의존성 점검(n=60×60)으로 한 모델만 끌어올린 항목을 갈라냈습니다                                                                                                                                                               |


## 2. 분류 체계와 처방


| 문서                                                                                                                                                | 크기          | 무엇이 있나                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ----------------------------------------------------------------------------------------------------------------- |
| [ai-tell-taxonomy.md](../plugin/skills/humanize-korean/references/ai-tell-taxonomy.md)                                                            | 121KB       | AI 한글 티 분류 체계 v2.0. 10대 카테고리(A 번역투, B 영어 인용 과다, C 구조적 패턴, D 관용구, E 리듬 균일성, F 과도한 수식, G 과도한 완곡 등)를 심각도 S1·S2로 나눕니다 |
| [quick-rules.md](../plugin/skills/humanize-korean/references/quick-rules.md)                                                                      | 17KB        | 한 콜짜리 빠른 경로가 쓰는 요약 룰북                                                                                             |
| [diagnosis-rules.md](../plugin/skills/humanize-korean/references/diagnosis-rules.md)                                                              | 16KB        | 진단 전용 슬림 색인. 무엇을 찾을지만 담고 처방은 빼 둔 판                                                                                |
| [rewriting-playbook.md](../plugin/skills/humanize-korean/references/rewriting-playbook.md)                                                        | 16KB        | 카테고리별 치환 레시피, 변경률 감시, 바꾸면 안 되는 어휘 목록, 장르별 조정                                                                      |
| [metrics.py](../plugin/skills/humanize-korean/references/metrics.py) · [metrics_v2.py](../plugin/skills/humanize-korean/references/metrics_v2.py) | 15KB · 31KB | 윤문 전에 돌리는 수치 계산기. v2는 post-editese 3축(단순화·정규화·간섭)과 번역 유형 신호 여덟을 더합니다. 표준 라이브러리만 씁니다                               |
| [baseline.json](../plugin/skills/humanize-korean/references/baseline.json)                                                                        | 8.4KB       | 장르별 기준값과 z 점수 임계, 어휘 사전                                                                                           |


**이 여섯은 [im-not-ai](https://github.com/epoko77-ai/im-not-ai)에서 커밋째 고정해 가져온 파일입니다.** 고치지 않습니다. 무엇을 어디까지 가져왔는지는 [plugin/NOTICE.md](../plugin/NOTICE.md)에 적혀 있습니다.

## 3. 이 저장소가 직접 만든 판정


| 무엇           | 어디                                                                                  | 무엇이 있나                                                                                                     |
| ------------ | ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| 작성 규칙        | [plugin/SKILL.md](../plugin/SKILL.md)                                               | 글을 처음 쓸 때 따르는 규칙. 핵심, 문장 만드는 법, 리듬, 서식, 품질 바, 자주 하는 실수                                                     |
| 검사 규칙 K1~K10 | [posttooluse.sh](../plugin/hooks-handlers/posttooluse.sh) 219~316행                  | 코드마다 정규식과 임계와 처방이 한 줄씩 붙어 있습니다                                                                             |
| 사람이 읽는 판정 정본 | [README.md](../README.md) 「판정 규칙」                                                   | 판정 순서 여덟 단계와 코드별 표                                                                                         |
| 답변 문체 지침     | [plugin/output-styles/korean-writing.md](../plugin/output-styles/korean-writing.md) | 골라 켜는 output style. 기본은 꺼져 있습니다                                                                            |
| 측정 기록        | [EVALUATION.md](../EVALUATION.md) A~N절                                              | 훅 정확도, 스킬 트리거, 비용, 주입이 일을 방해하는가, 블라인드 판정의 신뢰도, output style의 세부 보존                                         |
| 재현 장비        | [docs/experiments/](experiments/)                                                   | `always-on`, `detail-retention`, `hook-loop`, `output-style`, `skill-vs-imnotai`, `task-performance` 여섯 폴더 |
| 출처와 수정 범위    | [plugin/NOTICE.md](../plugin/NOTICE.md)                                             | 가져온 파일 목록과 고정한 커밋                                                                                          |


## 무엇을 찾을 때 어디로

- **이 표현이 왜 AI 티인가** → `ai-tell-taxonomy.md`에서 카테고리를 찾고, 학문적 뒷받침이 필요하면 `scholarship.md`
- **왜 이 패턴은 규칙에 없나** → `empirical-validation.md`의 기각 목록
- **훅이 왜 내 문장을 잡았나** → README 「판정 규칙」의 코드별 표, 그다음 `posttooluse.sh`의 해당 줄
- **어떻게 고치라는 말인가** → `rewriting-playbook.md`의 카테고리별 레시피
- **그 판정이 맞다는 근거** → `EVALUATION.md`의 해당 절과 `docs/experiments/`의 같은 이름 폴더

## 고칠 때

- 가져온 파일(2절)을 손대야 하면 `plugin/NOTICE.md`의 해당 줄도 함께 고칩니다.
- 판정 규칙을 바꾸면 `tools/measure.sh`로 실제 문서 뭉치의 오탐을 재고 결과를 `EVALUATION.md`에 남깁니다.
- `plugin/SKILL.md`를 고쳤으면 릴리스 전에 `docs/experiments/skill-vs-imnotai/run.sh`로 블라인드 판정을 돌립니다.

