# 한국어 AI 글 신호 분석 계획

플러그인 사용자를 위해 풀어 쓴 안내는 [README.md](README.md)에 있습니다. 이 문서는 기준, 계산식, 출처를 모두 적은 원본입니다.

> **상태:** 사전 등록 문서입니다(2026-09-15 작성). 2026-09-16 에 파일럿을 마쳤고 결과는 [11. 파일럿 결과](#11-파일럿-결과) 에 있습니다. 본 실행은 하지 않았습니다. 파일럿을 마친 뒤 한 번만 기준을 고칠 수 있고, 고치면 맨 끝 「갱신 이력」에 날짜와 이유를 적습니다. 본 실행 결과를 본 뒤에는 기준을 바꾸지 않습니다.
>
> **학습 미사용:** 이 분석에 쓰는 사람 글과 AI 글 표본, 그리고 측정 결과는 어떤 모델의 학습에도 사용하지 않았고 앞으로도 사용하지 않습니다.
>
> **수집한 글의 취급:** 모은 사람 글의 저작권은 원작자에게 있습니다. 본문은 저장소에 커밋하지 않고 출처 URL, 게시일 또는 판 번호, 저장 시각만 남깁니다.

이 문서는 근거를 네 종류로 나눠 표시합니다. **논문**은 원문을 열어 문장을 확인한 연구이고, **저장소 자료**는 이 저장소에 있는 파일입니다. **2차 인용**은 다른 자료가 인용한 연구로 원문을 아직 열지 않은 것이며, **직접 실험**은 이 문서를 쓰며 돌린 명령과 그 출력입니다. 출처 목록은 [10. 출처](#10-출처) 에 있고 본문에서는 [번호]로 가리킵니다.

## 1. 이 분석을 하는 이유

2026-09-14 에 검사 훅을 개편하며 한 측정은 근거가 되지 못했습니다. 이유는 셋입니다.

1. 사람 글을 파일 수정 연도로 추정했습니다. 2023년 이전에 수정된 파일 32편을 사람 글로 셌고 작성자는 확인하지 않았습니다.
2. 규칙을 빼는 변경에 「사람 글 오탐이 늘지 않을 것」이라는 기준을 썼습니다. 규칙을 빼면 걸리는 글은 줄기만 하므로 떨어질 수 없는 기준이었습니다.
3. 합격선을 결과를 본 뒤에 적었습니다.

이 판단은 EVALUATION.md O절 「O3 은 근거가 되지 않는다」와 커밋 `b2e2089` 에 기록돼 있습니다[\[R1\]](#r1). 그래서 이번에는 작성자가 확인된 사람 글과 같은 주제의 AI 글을 표본으로 쓰고, 기준을 결과보다 먼저 이 문서에 적습니다.

## 2. 묻는 질문

- **Q1.** 한국어 AI 글과 사람 글을 가르는 표층 신호는 무엇이고, 신호마다 심각도는 얼마인가.
- **Q2.** 사람 글을 한 편도 잡지 않으면서 AI 글을 얼마나 잡는 분석 도구를 만들 수 있는가.
- **Q3.** output style 로 배포되는 한국어 플러그인 가운데, 의미를 잃지 않으면서 AI 신호가 가장 적은 글을 쓰게 하는 것은 무엇인가.
- **Q4.** 한국어 교정·윤문 도구 가운데 이 플러그인에 내장할 만한 것은 무엇인가.

## 3. 확정한 결정

아래는 2026-09-15 대화에서 사용자가 정했습니다. 앞의 여덟 줄은 계획 초안 전에, 뒤의 네 줄(개인 블로그, 교정 도구 범위, 「가를 수 없다」 처리, 비용 승인)은 초안을 쓴 뒤에 정했습니다. 「후보 패턴을 만드는 근거」 줄은 2026-09-16 에 더했습니다.

| 항목 | 결정 | 비고 |
| --- | --- | --- |
| 사람 글 출처 | 한국어 위키백과의 옛 판, 기업 기술 블로그 글, 개인 블로그 글 | im-not-ai 코퍼스는 공개되지 않아 쓸 수 없음([8.2 im-not-ai 코퍼스는 받을 수 없다](#82-im-not-ai-코퍼스는-받을-수-없다)). 개인 블로그는 단조로운 글의 오판 편향을 확인하려고 넣음([5.5 편향 점검](#55-편향-점검)) |
| 날짜 기준 | 2022-11-30 이전 | ChatGPT 가 처음 공개된 날짜입니다[\[S7\]](#s7) |
| AI 글 | Claude 만 씀. claude-opus-5 와 claude-sonnet-5, output style 없음 | 사람 글과 같은 주제로 씁니다 |
| 분석 수단 | 훅이 아닌 분석 전용 명령줄 도구 | 평소에는 적용하지 않습니다. 형태소 분석기를 씁니다 |
| 분석 도구의 동작 | 알리기만 하고 고치게 하지 않음 | |
| 패턴 채택 기준 | 사람 글 0건이고, 그 패턴에만 걸리는 AI 글이 1편 이상 | |
| 문서 판정 기준 | 선별용과 검증용 사람 글 모두에서 0건 | [5.4 문턱과 표본 수](#54-문턱과-표본-수) |
| 상시 적용 비교 대상 | output style 로 배포되는 한국어 플러그인 전부. 스타 수 기준 없음 | |
| 후보 패턴을 만드는 근거 | 심사를 거친 연구와 국가 연구기관 간행물이 보고한 특징만. 심사 전 논문, 도구 문서, 자체 측정은 보조 근거로만 씀 | 2026-09-16 에 정함. 5.2 |
| 교정 도구 비교 대상 | 찾은 후보 전부([6.2 교정 도구 후보](#62-교정-도구-후보)). 스타 수 기준 없음 | 맞춤법 검사기는 이용 조건 때문에 제외 |
| 「가를 수 없다」가 나올 때 | 그때 사용자와 다시 의논 | 결과를 본 뒤 기준을 바꾸면 사후 조정이므로 [5.6 결과가 「가를 수 없다」일 때](#56-결과가-가를-수-없다일-때) 의 기록 규칙을 따름 |
| 본 실행 비용 | 파일럿 뒤에 승인 | 파일럿에서 잰 호출당 비용으로 견적을 냄 |
| 결과 문서 | 이 문서 | 방법, 순서, 기준, 결과, 채택 이유를 적습니다 |



## 4. 표본 설계

### 4.1 사람 글

- **수:** 750편 이상입니다. 패턴을 고르는 선별용 375편과 문턱을 확인하는 검증용 375편으로 나눕니다. 검증용이 299편 이상이어야 하는 이유는 [5.4 문턱과 표본 수](#54-문턱과-표본-수) 에 있습니다.
- **장르:** 위키 글 300편, 기술 블로그 글 300편, 개인 블로그 글 150편이고, 장르마다 선별용과 검증용에 반씩 넣습니다.
- **위키 글:** 무작위로 고른 문서의 2022-11-30 이전 마지막 판을 받습니다. 본문 문단만 뽑고 각주 번호를 지우며, 한글 800자 이상인 문서만 씁니다. 날짜의 근거는 API 가 돌려주는 판 저장 시각입니다([8.1 위키백과 옛 판을 받을 수 있다](#81-위키백과-옛-판을-받을-수-있다)).
- **기술 블로그 글:** 다섯 곳 이상에서 모으고 한 필자의 글은 두 편까지만 넣습니다(파일럿은 회사마다 두 편까지). 표본 틀은 한국어 기업 기술 블로그 목록 `maczniak/awesome-korean-techblog` 의 2022-11-30 이전 마지막 커밋(`68fbe20`, 2022-06-17) README 가운데 「기업 블로그」 절입니다. 회사 순서를 시드 `20260916` 으로 섞어 앞에서부터 고르고, 회사 안에서도 글 주소를 같은 시드로 섞어 고릅니다. 글 목록 쪽이 섞이지 않게 `og:type` 이 `article` 이거나 JSON-LD 에 글 표시가 있는 쪽만 씁니다. 코드 블록은 분석에서 뺍니다.
- **개인 블로그 글:** 티스토리, 네이버 블로그, 벨로그, 브런치에서 필자를 가려 모으고 한 필자의 글은 두 편까지만 넣습니다(파일럿은 한 편). 표본 틀은 개인 개발 블로그 목록 `sarojaba/awesome-devblog` 의 `db.yml`(마지막 커밋 `1106089`, 2021-12-11)에서 블로그 주소가 이 네 곳인 759명입니다(티스토리 357, 벨로그 175, 브런치 157, 네이버 70). 필자 순서를 시드 `20260916` 으로 섞어 앞에서부터 고릅니다.
- **게시일 대조(2026-09-16 파일럿 전 변경):** 블로그 글은 Common Crawl 이 2022-11-30 전에 수집한 쪽만 씁니다. 색인에서 상태 200, HTML, 한국어로 표시된 수집본 가운데 수집 시각이 기준일보다 앞선 것을 고르고, 본문도 그 수집본(WARC)에서 뽑습니다. 그러면 수집 시각이 게시일의 상한이 되고, 나중에 고친 글이 섞이지 않습니다. 원래 계획한 Wayback 대조는 2026-09-15 와 09-16 모두 쓸 수 없어 이 방법으로 바꿨습니다([8.7 Wayback 대신 Common Crawl](#87-wayback-대신-common-crawl)).
- **본문 추출:** 위키 글은 판 HTML 의 `<p>` 문단만 뽑고, 블로그 글은 수집본 HTML 을 trafilatura 로 뽑아 마크다운으로 받습니다([8.5 도구](#85-도구)). 그다음 사람 글과 AI 글에 같은 정리 함수를 적용해 코드 블록, 표, 마크다운 기호를 뺍니다. 모든 장르에서 정리한 뒤 한글 800자 이상인 글만 씁니다. WebFetch 는 페이지를 모델이 요약해 돌려주므로 본문 수집에 쓰지 않습니다.
- **기록:** 출처 URL, 게시일 또는 판 번호와 저장 시각, 필자, 뽑은 한글 글자 수를 목록 파일로 커밋합니다. 본문은 `docs/experiments/ai-writing-signals/out/` 에 두며 `.gitignore` 가 커밋을 막습니다.

### 4.2 AI 글

- **짝:** 사람 글 한 편마다 같은 제목, 같은 장르, 비슷한 분량(±20%)으로 두 모델이 한 편씩 씁니다. 모두 1,500편입니다.
- **생성 조건:** `claude -p` 로 사용자 설정과 MCP 도구를 빼고(`--setting-sources ""`, `--strict-mcp-config`) 도구 없이 씁니다.
- **실행:** 빈 임시 폴더에서 `claude -p <프롬프트> --model <모델> --tools "" --setting-sources "" --strict-mcp-config --no-session-persistence --max-turns 1 --output-format json` 으로 씁니다(Claude Code 2.1.272). 기본 시스템 프롬프트는 그대로 둡니다. 이 플러그인이 다루는 것이 Claude Code 가 쓰는 글이기 때문입니다([8.8 생성 호출](#88-생성-호출)).
- **분량:** 목표는 짝이 되는 사람 글의 한글 글자 수를 10 자리에서 반올림한 값입니다. 결과가 목표의 ±20% 를 벗어나면 한 번 다시 쓰게 하고, 두 번째 결과는 벗어나도 쓰되 표시합니다.
- **정리:** 사람 글과 같은 정리 함수를 적용합니다. 위키 사람 글은 `<p>` 문단뿐이므로 위키 AI 글에서는 제목, 목록, 인용 줄도 뺍니다.
- **프롬프트(2026-09-16 파일럿 전 확정):** 장르마다 아래 템플릿을 씁니다(`docs/experiments/ai-writing-signals/prompts/`). `{title}` 에는 사람 글 제목을, `{chars}` 에는 목표 글자 수를 넣습니다.

위키:

```text
다음 제목으로 한국어 위키백과 문서의 본문을 써 주세요.

제목: {title}
분량: 한글 약 {chars}자

본문 문단만 출력하세요.
```

기술 블로그:

```text
다음 제목으로 한국어 기술 블로그 글을 써 주세요.

제목: {title}
분량: 코드를 뺀 한글 약 {chars}자

글 본문만 출력하세요.
```

개인 블로그:

```text
다음 제목으로 한국어 개인 블로그 글을 써 주세요.

제목: {title}
분량: 한글 약 {chars}자

글 본문만 출력하세요.
```

### 4.3 파일럿

사람 글 30편(위키 10, 기술 블로그 10, 개인 블로그 10)과 AI 글 30편(두 모델 15편씩)으로 수집부터 지표 계산까지 한 번 끝까지 돌립니다. 확인할 것은 두 가지입니다.

1. 수집, 추출, 형태소 분석, 지표 계산이 틀리지 않고 도는가.
2. 사람 글 0건을 지키면서 AI 글을 잡는 신호가 남을 가망이 있는가.

사람 글 한 편마다 AI 글을 한 편씩 짝지어 씁니다. 모델은 장르마다 id 순서로 claude-opus-5 와 claude-sonnet-5 를 번갈아 써서, 장르마다 두 모델이 5편씩입니다.

파일럿 사람 글은 30편뿐이라 선별용과 검증용을 따로 두지 않습니다. 대신 장르마다 시드 `20260916` 으로 사람 글을 반씩 나눠, 선별용 반의 최댓값·최솟값을 문턱으로 삼았을 때 검증용 반의 사람 글이 몇 편 문턱을 넘는지 함께 봅니다. 두 번째 확인(가망)은 이 수치로 판단합니다.

가망이 없으면 본 실행으로 넘어가지 않고 사용자와 다시 정합니다. 파일럿 표본은 본 실행 표본과 겹치지 않게 합니다.

## 5. 분석 방법

### 5.1 분석 도구

파일이나 폴더를 넣으면 문서마다 패턴별 수치를 JSON 으로 냅니다. 같은 입력에는 늘 같은 출력을 내야 합니다. 형태소 분석에는 Kiwi(`kiwipiepy` 0.23.2)의 기본 모델을 쓰고 오타 교정은 켜지 않습니다. 의존 거리(5.2 의 27번)는 spaCy 3.8.16 의 `ko_core_news_sm` 3.8.0 으로 어절 단위로 잽니다([8.5 도구](#85-도구)). 도구는 `docs/experiments/ai-writing-signals/signals.py` 이고, 지표마다 어떤 형태와 품사를 세는지는 그 파일의 `FEATURES` 와 함수 본문에 있습니다. 분석기가 틀리면 숫자 전체가 틀리므로, 파일럿에서 20문장의 형태소와 띄어쓰기 판정을 사람이 원문과 대조합니다.

### 5.2 후보 패턴과 근거 상태

**후보를 만드는 규칙 (2026-09-16 사용자 결정).** 후보는 신뢰할 수 있는 연구가 보고한 특징에서만 만듭니다. 신뢰할 수 있는 연구란 동료 심사를 거친 학술지·학회 논문, 그리고 국가 연구기관(국립국어원)의 간행물입니다. 그 연구가 사람 글과 AI 글, 또는 한국어 번역문과 비번역문을 코퍼스로 비교해 차이를 보고한 특징만 후보가 됩니다. 심사 전 논문(arXiv), 도구 문서, 자체 측정, 이 저장소의 관찰은 후보를 만들 수 없고 보조 근거로만 적습니다.

이 규칙으로 모은 후보는 **43가지**입니다. 근거는 세 등급으로 표시합니다.

| 등급 | 뜻 |
| --- | --- |
| A | 한국어 AI 글(또는 AI 를 활용해 쓴 한국어 글)과 사람 글을 비교한 심사 연구 |
| B | 다른 언어(영어·일본어)에서 AI 글과 사람 글을 비교하거나, 기계 번역 후편집과 사람 번역을 비교한 심사 연구 |
| C | 한국어 번역문과 비번역문을 비교한 코퍼스 연구 |

A 등급 연구는 두 편입니다. KatFishNet[\[S1\]](#s1)은 에세이, 시, 논문 초록을 다뤘고, 박종향·김은영(2025)[\[S24\]](#s24)은 AI 활용 여부를 학년도로 가른 대학생 과제물 69편을 다뤘습니다. 그래서 등급이 높아도 이 분석의 장르(위키, 기술 블로그, 개인 블로그)에서 같은 방향이 나오리라고 가정하지 않습니다. 모든 후보는 [5.3 심각도 등급](#53-심각도-등급) 의 방식으로 우리 표본에서 다시 잽니다. 등급은 결과를 해석할 때 참고하는 값이고 채택 기준을 바꾸지 않습니다.

| # | 후보 | 한국어로 재는 방법(초안) | 연구가 보고한 것 | 등급 |
| --- | --- | --- | --- | --- |
| | **가. 문장부호와 표기** | | | |
| 1 | 쉼표 포함률 | 쉼표가 든 문장의 비율 | [\[S1\]](#s1) 에세이 사람 26.31%, LLM 61.03%. 시와 초록도 LLM 이 높음 | A |
| 2 | 쉼표 사용률 | 어절에 대한 쉼표의 비율 | [\[S1\]](#s1) 에세이 사람 1.13%, LLM 2.56% | A |
| 3 | 쉼표의 문장 안 위치 | 문장 길이에 대한 쉼표의 상대 위치 | [\[S1\]](#s1) 에세이 사람 0.09, LLM 0.18 로 LLM 이 더 뒤에 둠. [\[S10\]](#s10) 일본어 학술문에서도 쉼표 위치가 분류 변수(방향은 초록에 없음) | A, B |
| 4 | 쉼표로 나뉜 구간 길이 | 쉼표 사이 구간의 평균 어절 수 | [\[S1\]](#s1) 에세이 사람 4.35, LLM 8.56 | A |
| 5 | 쉼표 앞뒤 품사 쌍의 다양성 | 쉼표 앞뒤 품사 쌍의 종류 수 ÷ 전체 쌍 수 | [\[S1\]](#s1) 에세이 사람 24.38, LLM 59.39 | A |
| 6 | 문장부호 전체 빈도 | 1,000자당 문장부호 | [\[S12\]](#s12) 영어 뉴스에서 사람이 문장부호를 더 씀 | B |
| 7 | 띄어쓰기 규칙 준수도 | 띄어쓰기 규칙에서 벗어난 비율과 그 분산 | [\[S1\]](#s1) 에세이와 시에서 사람 글의 띄어쓰기 비율이 낮음. LLM 에세이의 BN 띄어쓰기 비율은 표준편차 0.02 로 거의 일정 | A |
| | **나. 어휘** | | | |
| 8 | 어휘 다양도 | 길이를 보정한 어휘 다양도(MATTR, MTLD 등) | [\[S1\]](#s1) LLM 이 더 좁은 어휘를 씀(부록 L). [\[S24\]](#s24) AI 를 활용한 대학생 글이 TTR·MATTR 이 낮음. [\[S12\]](#s12) 영어 뉴스에서 사람이 높음. [\[S13\]](#s13) GPT-3 에세이는 사람보다 낮고 GPT-4 에세이는 높음. [\[S25\]](#s25) 네 ChatGPT 모델이 여섯 차원 모두에서 사람과 달랐고, ChatGPT-4.5 는 옛 모델보다 다양도가 높음. [\[S16\]](#s16) 후편집 번역이 사람 번역보다 낮음. [\[S21\]](#s21) 영한 번역문이 낮음 | A, B, C |
| 9 | 어휘 밀도 | 내용어 비율 | [\[S16\]](#s16) 기계 번역 후편집이 사람 번역보다 낮음 | B |
| 10 | 과용 스타일 어휘 | 사람 글보다 과하게 쓰는 어휘를 선별용 표본에서 뽑음 | [\[S5\]](#s5) LLM 등장 뒤 생의학 초록에서 특정 스타일 어휘가 급증. [\[S15\]](#s15) 과학 초록의 초점 어휘 21개 | B |
| | **다. 품사와 문법 형태** | | | |
| 11 | 품사 n-gram 다양성 | 품사 1~5-gram 의 종류 수 ÷ 전체 수 | [\[S1\]](#s1) 에세이·시·초록에서 사람이 더 다양. 시의 4·5-gram 만 예외(부록 E) | A |
| 12 | 품사 bigram 분포 | 품사 bigram 의 상대 빈도 | [\[S10\]](#s10) [\[S11\]](#s11) 일본어에서 AI 글을 가르는 분류 변수(방향은 초록에 없음) | B |
| 13 | 기능어 비율과 분포 | 조사·어미의 종류별 빈도 | [\[S10\]](#s10) 일본어 학술문에서 기능어 비율만으로 정확도 98.1%. [\[S11\]](#s11) 기능어 unigram 이 분류 변수(방향은 초록에 없음) | B |
| 14 | 조사 bigram | 이어 나오는 조사 쌍의 빈도 | [\[S10\]](#s10) 일본어 조사 bigram 이 분류 변수(방향은 초록에 없음) | B |
| 15 | 어절 패턴 | 어절 안의 형태소 배열 유형 | [\[S11\]](#s11) 일본어 구 패턴이 분류 변수. 한국어 대응 단위는 파일럿 전에 정의 | B |
| 16 | 명사·형용사와 관형 수식 | 명사·형용사 비율, 관형 수식 구조 | [\[S12\]](#s12) 영어 뉴스에서 사람이 명사·형용사를 더 쓰고 LLM 은 형용사 수식과 동격 구조가 적음 | B |
| 17 | 명사화 | `-성`·`-화` 파생 명사, 명사형 어미 | [\[S13\]](#s13) ChatGPT 에세이가 사람보다 많음(1.06 대 1.56·1.73). [\[S14\]](#s14) 지시 조정 모델이 사람의 1.5~2배 | B |
| 18 | 보조 용언 | `-고 있다`·`-아/어 왔다`·`-을 것이다` 등 | [\[S12\]](#s12) 영어 뉴스에서 LLM 이 조동사를 더 씀. [\[S21\]](#s21) 영한 번역문에 보조 용언 시간 표현이 많음 | B, C |
| 19 | 대명사 | 1,000자당 인칭·지시 대명사 | [\[S12\]](#s12) 영어 뉴스에서 LLM 이 더 씀. [\[S21\]](#s21) 영한 번역문에 2·3인칭 대명사가 많고 1인칭이 적음 | B, C |
| 20 | 숫자·기호 | 1,000자당 숫자와 기호 | [\[S12\]](#s12) 영어 뉴스에서 LLM 이 더 씀 | B |
| 21 | 관형격 조사 `-의` | 1,000자당 빈도 | [\[S21\]](#s21) 영한 번역문에 많음 | C |
| 22 | `은/는` 과 `이/가` 의 비 | 주제 보조사와 주격 조사의 상대 빈도 | [\[S21\]](#s21) 영한 번역문에 `은/는` 이 과도하게 많고 `이/가` 가 적음 | C |
| 23 | 의존명사 `것/거`·`때문` | 1,000자당 빈도 | [\[S21\]](#s21) 영한 번역문에 많음 | C |
| | **라. 문장 구조** | | | |
| 24 | 평균 문장 길이 | 문장당 어절 수 | [\[S24\]](#s24) AI 를 활용한 대학생 글이 더 짧음. [\[S12\]](#s12) 영어 뉴스에서 사람이 긴 문장을 더 자주 씀. [\[S20\]](#s20) 번역·비번역 기사문의 평균 문장 길이가 다름(방향은 초록에 없음) | A, B, C |
| 25 | 문장 길이 분산 | 문장 길이의 변동계수 | [\[S12\]](#s12) LLM 글의 문장 길이가 더 균일 | B |
| 26 | 문장당 절 수와 종속절 | 문장당 절 수, 종속 연결어미 빈도 | [\[S13\]](#s13) ChatGPT 에세이의 문장당 절 수가 많음(1.81 대 2.31·2.08). [\[S12\]](#s12) LLM 이 종속절을 더 씀 | B |
| 27 | 의존 거리 | 의존 관계의 평균 거리 | [\[S12\]](#s12) 사람이 의존 거리를 더 짧게 최적화 | B |
| 28 | 구 등위 접속 | `와/과`·`및` 으로 이은 명사구 | [\[S14\]](#s14) GPT-4o 가 사람의 1.9배. [\[S21\]](#s21) 영한 번역문에는 `및` 이 적음 | B, C |
| 29 | 장형 사동 | `-게 하다`·`-게 만들다` | [\[S21\]](#s21) 영한 번역문에 많음 | C |
| 30 | 부정 형식 | 단형 부정 `안/못` 과 `-ㄹ 수 없다` 의 비 | [\[S21\]](#s21) 영한 번역문에 단형 부정이 적고 `-ㄹ 수 없다` 가 많음 | C |
| | **마. 양태와 담화** | | | |
| 31 | 양태 표현 | `-ㄹ 수 있다`·`-아야 하다` 등 | [\[S13\]](#s13) 사람이 더 씀(10.84 대 8.97·6.12) | B |
| 32 | 인식 표지 | `-것 같다`·`아마` 등 | [\[S13\]](#s13) 사람이 더 씀(0.06 대 0.02·0.00) | B |
| 33 | 담화 표지 | 담화 표지 목록의 빈도 | [\[S13\]](#s13) 사람이 GPT-4 보다 더 씀(0.57 대 0.36) | B |
| 34 | 완화어 | `거의`·`약간` 등 | [\[S14\]](#s14) GPT-4o 가 사람보다 더 씀 | B |
| 35 | 정도 부사 | `가장`·`매우`·`아주`·`너무` | [\[S21\]](#s21) 영한 번역문에 많음 | C |
| 36 | 접속사의 종류 | 예시·강조 접속사와 조건 접속사의 비 | [\[S24\]](#s24) AI 를 활용한 대학생 글에 예시·강조 접속사가 많고 조건 접속사가 적음. 접속 부사의 빈도와 다양성 자체는 차이 없음 | A |
| 37 | 대조·전환 접속사 | `그러나`·`하지만` 과 `그런데` 의 비 | [\[S21\]](#s21) 영한 번역문에 대조 접속이 많고 전환 접속이 적음 | C |
| 38 | 감정 표현 | 감성 점수, 부정 감정 어휘 | [\[S12\]](#s12) LLM 이 공포·분노 같은 부정 감정을 덜 드러냄. [\[S24\]](#s24) AI 를 활용한 대학생 글과 사람 글의 감성 점수는 차이 없음 | A, B |
| | **바. 번역투 어휘** | | | |
| 39 | `대하다`·`의하다`·`만들다`·`가지다` | 1,000자당 빈도 | [\[S21\]](#s21) 영한 번역문에 많음 | C |
| 40 | 피동 표현 | `-아/어 지다`, `-에 의하여` 행위자 피동 | [\[S21\]](#s21) 영한 번역문에 많음. [\[S14\]](#s14) GPT-4o 는 영어에서 행위자 없는 피동을 사람의 절반쯤만 씀(방향이 엇갈림) | B, C |
| 41 | `~통하다` | 5만 어절당 빈도 | [\[S19\]](#s19) 비번역 기사문 84.44, 번역 기사문 42.09 로 비번역이 두 배(통념과 반대) | C |
| 42 | 존칭 표현 | 존칭 대명사, 선어말 어미 `-(으)시-` | [\[S21\]](#s21) 영한 번역문의 2·3인칭 대명사에 존칭이 많고, `-(으)시-` 주체 존대가 적음 | C |
| 43 | 지시어와 인용 방식 | 지시어 빈도, 직접·간접 인용 비 | [\[S20\]](#s20) 번역·비번역 기사문 사이에 차이(방향은 초록에 없음) | C |

**연구끼리 방향이 엇갈리는 후보가 있습니다.** 어휘 다양도는 GPT-3 에세이에서 사람보다 낮고 GPT-4 에세이에서 높았습니다[\[S13\]](#s13). 명사는 영어 뉴스에서 사람이 더 썼지만[\[S12\]](#s12) 명사화는 AI 가 더 썼습니다[\[S13\]](#s13)[\[S14\]](#s14). 피동은 영한 번역문에 많았지만[\[S21\]](#s21) GPT-4o 는 적게 썼습니다[\[S14\]](#s14). 이런 후보는 방향을 미리 정하지 않고 우리 표본에서 잰 방향을 따릅니다.

**방향이 초록에 없는 후보도 있습니다.** 일본어 연구[\[S10\]](#s10)[\[S11\]](#s11)는 품사 bigram, 기능어, 조사 bigram, 구 패턴이 AI 글을 가른다고 보고했지만 어느 쪽이 많은지는 초록에 적지 않았습니다. 이 후보들은 분포 전체를 비교합니다.

**후보에서 뺀 것.** 널리 알려졌거나 이 저장소의 검사 훅이 쓰는 표현이지만, 위 규칙에 맞는 연구를 찾지 못한 것입니다.

| 뺀 것 | 이유 |
| --- | --- |
| 부정 대구 `A가 아니라 B` | im-not-ai 의 자체 측정[\[R6\]](#r6)뿐이고 심사받은 연구를 찾지 못함 |
| 줄표 삽입구 | 심사 전 논문 하나[\[S18\]](#s18)는 초록에 사람 글과의 비교가 없고, 사람 글과 비교한 심사 연구를 찾지 못함. 검사 훅 K1 의 규칙 |
| 이중 피동 `되어진다` | 빈도를 비교한 연구를 찾지 못함. 국립국어원 답변[\[S23\]](#s23)은 규범에 관한 질의응답이라 빈도를 다루지 않음 |
| 복수형 `-들` 과다 | 과다를 보고한 연구를 찾지 못함. 번역 소설 한 권을 센 연구[\[S22\]](#s22)에서 영어 무정명사 복수형에 `-들` 을 붙인 비율은 6.8%였음 |
| 추상 구조어(`축`·`갈래`·`레이어`), 평가 수식(`혁신적` 등), 승패·사물 의인화, `것들` 구문 | 검사 훅 K2·K3·K4·K6·K7 의 규칙이지만 사람 글과 비교한 연구를 찾지 못함. `것` 과 `가지다` 는 번역문 연구[\[S21\]](#s21)가 보고해 23·39번 후보로 들어감 |

결과 절에는 등급을 함께 적어, 우리 표본에서만 나온 결과인지 다른 연구와 방향이 같은 결과인지 구분합니다.

**구현하며 정한 것(2026-09-16, 파일럿 전).** 표의 「한국어로 재는 방법(초안)」을 `signals.py` 로 옮기며 다음을 정했습니다.

- 4번 구간 길이는 KatFishNet 에서 단위를 확인하지 못해 형태소 수로 셉니다.
- 16번은 명사 비율, 형용사 비율, 관형형 어미·관형사 밀도의 세 값으로, 43번은 지시어 밀도와 인용격 조사 밀도의 두 값으로 나눠 잽니다. 그래서 문서마다 값이 하나인 지표는 37개 후보에서 나온 40개입니다.
- 10번과 12~15번은 문서 하나의 값이 아니라 항목 목록이므로, 항목마다 로그 오즈 z 로 차이를 봅니다. 같은 표본에서 고른 항목이라 파일럿에서는 탐색 결과로만 보고합니다.
- 38번 감정 표현은 한국어 감성을 잴 수단을 정하지 않아 파일럿에서 재지 않습니다. 수단은 파일럿 보고 때 사용자와 정합니다.

### 5.3 심각도 등급

기존 규칙집의 S1·S2·S3 는 사람이 판단해 매긴 등급입니다[\[R6\]](#r6). 이 분석에서는 등급을 **선별용 표본에서 계산해** 매깁니다.

| 등급 | 조건 |
| --- | --- |
| 결정적 | 선별용 사람 글에서 한 번도 나오지 않고, AI 글에서는 한 번 나오는 것만으로 적중하는 문서가 있음 |
| 누적 | 사람 글이 0건이 되는 최소 반복 횟수 k 를 패턴마다 따로 찾음. k 는 「3회」처럼 고정하지 않음. 긴 문서에 불리하지 않게 1,000자당 밀도로도 계산함 |
| 보조 | 사람 글에도 나오지만 AI 쪽 비율이 더 높음. 단독 판정에는 쓰지 않고 문서 점수에만 더함 |
| 기각 | AI 쪽이 더 높지 않음. 또는 두 모델이나 두 장르 가운데 한쪽에서 방향이 반대로 나옴 |

계산은 네 단계로 합니다.

1. **패턴 고르기:** 어휘나 품사 조합처럼 항목이 여럿인 빈도는 분산을 보정한 로그 오즈의 z 점수로 잽니다[\[S3\]](#s3). 드문 표현이 빈도 차이만 크게 보이는 문제를 막으려는 것입니다. 사전분포는 두 묶음을 합친 빈도에 비례하게 두고, 그 합(α0)은 1,000 으로 둡니다. 이 값은 이 분석이 정했고 출처가 없습니다. 문서마다 값이 하나인 지표(비율, 평균 문장 길이 등)는 두 묶음의 분포를 Mann–Whitney U 양측 검정으로 비교합니다(SciPy 1.18.1). 여러 지표를 동시에 검정하므로 Benjamini–Yekutieli 방법으로 거짓 발견률을 q = 0.05 에서 통제합니다[\[S26\]](#s26). 이 방법을 고른 이유는 지표끼리 서로 얽혀 있기 때문입니다(예: 쉼표 지표 다섯 개). 이 방법은 독립이나 양의 의존을 가정하지 않습니다.
2. **증거 합산:** 패턴마다 로그 우도비를 구하고 더해 문서 점수를 냅니다. Mosteller 와 Wallace 가 기능어 빈도로 저자를 가를 때 쓴 방식입니다[\[S4\]](#s4). 이들은 한 단어로 판정하지 않고 여러 단서를 모았으며, 서로 관련된 단어는 로그 오즈를 조정했습니다. 그래서 서로 겹치는 패턴(예: 쉼표 과다와 연결어미 뒤 쉼표)은 묶어서 한 묶음에서 가장 강한 것만 더합니다.
3. **단일 지표 금지:** 한 지표만으로 문서를 판정하지 않습니다. 규칙집에 반례가 기록돼 있습니다[\[R6\]](#r6). 2020년에 사람이 쓴 에세이가 연결어미 뒤 쉼표 하나로 최고 위험 판정을 받았는데, 필자의 개인 습관이었습니다.
4. **판정 보류:** 짧은 글은 비율이 크게 흔들리므로 최소 글자 수에 못 미치면 판정하지 않습니다. 최소 글자 수는 파일럿 결과로 정해 이 절에 적습니다.

**적중의 정의(2026-09-16, 파일럿 전).** 연구가 보고한 방향이 「AI 가 높음」인 지표는 사람 글 최댓값보다 큰 AI 글을, 「AI 가 낮음」인 지표는 최솟값보다 작은 AI 글을 적중으로 셉니다. 연구끼리 방향이 엇갈리거나 방향이 없는 지표는 표본에서 본 방향을 쓰고, 결과에 그렇게 정했다고 표시합니다. 「그 패턴에만 걸리는 AI 글」은 다른 어떤 지표에도 적중하지 않은 AI 글입니다. 두 모델이나 세 장르 가운데 한쪽에서 중앙값의 방향이 반대로 나오면 결과에 표시합니다.

### 5.4 문턱과 표본 수

문서 점수의 문턱은 사람 글 점수로 정합니다(Neyman-Pearson 방식)[\[S2\]](#s2). 검증용 사람 글의 최고 점수보다 높게 잡아 사람 글 0건을 맞춥니다. 이 방식에는 표본 수 조건이 있습니다[\[S2\]](#s2).

- 사람 글 표본이 n ≥ log δ / log(1 − α) 편 있어야 「모집단 오탐률이 α 를 넘을 확률이 δ 이하」라고 말할 수 있습니다.
- α = 1%, δ = 5% 이면 299편이 필요합니다([8.6 Neyman-Pearson 표본 수 계산](#86-neyman-pearson-표본-수-계산)). 검증용 375편은 이 조건을 넘습니다.
- 150편이면 같은 δ 에서 보장되는 α 가 약 1.98%로 올라갑니다([8.6 Neyman-Pearson 표본 수 계산](#86-neyman-pearson-표본-수-계산)).

0건이 나왔을 때의 상한은 「3의 규칙」으로도 확인합니다[\[S6\]](#s6). n 편에서 0건이면 95% 신뢰 상한은 약 3/n 이므로, 300편이면 1% 입니다. 이 두 계산이 검증용 사람 글을 300편 가까이 이상 모으는 이유입니다. 개인 블로그를 더하면서 검증용은 375편이 됐습니다.

모은 표본 밖에서까지 오탐 0%를 보장할 수는 없습니다. 이 문서가 보장하는 것은 「검증용 표본에서 0건, 모집단 오탐률 1% 이하를 95% 확신」까지입니다.

### 5.5 편향 점검

단조롭고 평이한 글이 AI 글로 오판되는 편향이 알려져 있습니다. 영어 GPT 탐지기는 비원어민이 쓴 글을 AI 글로 잘못 분류했습니다[\[S8\]](#s8). 위키와 기술 블로그 글은 편집을 거친 글이라 이런 글이 적습니다. 그래서 개인 블로그 글 150편을 넣고, 결과를 장르별로도 따로 보고해 개인 블로그에서만 오탐이 몰리는지 확인합니다.

### 5.6 결과가 「가를 수 없다」일 때

사람 글 0건을 지키면서 AI 글을 잡는 패턴이 거의 남지 않을 수 있습니다. 그 경우에도 결과를 먼저 그대로 기록합니다. 그다음 무엇을 할지는 그때 사용자와 다시 의논합니다. 결과를 본 뒤 기준을 바꾸게 되면 사후 조정이므로 세 가지를 지킵니다.

1. 원래 기준으로 낸 결과를 지우지 않고 남깁니다.
2. 바꾼 기준과 바꾼 이유를 「갱신 이력」에 「사후 변경」이라고 표시해 적습니다.
3. 바꾼 기준으로 낸 결과는 사전 등록 결과와 구분해 보고합니다.

## 6. 플러그인 비교 방법

### 6.1 output style 플러그인 조사

스타 수와 관계없이 output style 로 배포되는 한국어 플러그인을 모두 찾습니다. 「모두 찾았다」고 보장할 수단은 없으므로, 어떤 방법으로 찾았는지를 이 절에 남깁니다. 2026-09-15 까지 쓴 방법은 다음과 같습니다.

- GitHub 저장소 검색: `korean --topic claude-code`, `한국어 --topic claude-skills`
- GitHub 코드 검색: `keep-coding-instructions 한국어` (결과 0건)
- 한국어 스킬 목록 저장소 `J-nowcow/awesome-korean-agent-skills` 의 「글쓰기 & 한국어」 분류
- 웹 검색: 「Claude Code 한국어 플러그인 output style 스킬 GitHub 추천 목록」

지금까지 output style 로 배포되는 한국어 플러그인으로 확인한 것은 하나입니다.

| 저장소 | 스타(2026-09-15) | 확인한 것 |
| --- | --- | --- |
| snflkd/fluent-korean | 1,275 | 저장소 설명이 「output-style 플러그인」 |

`sangrokjung/claude-forge`(스타 836)의 `rules/korean-writing-quality.md` 는 output style 이 아닌 규칙 파일이고, 파일 머리에 `load: conditional` 과 `paths`(블로그·보고서·`*.ko.md` 등)가 적혀 있습니다. 이 값에 따라 실제로 언제 적용되는지는 확인하지 않았습니다. output style 만 비교하기로 했으므로 넣지 않습니다.

### 6.2 교정 도구 후보

스타 수와 관계없이 찾은 후보를 모두 비교합니다([3. 확정한 결정](#3-확정한-결정)). 2026-09-15 에 찾은 후보는 다음과 같습니다.

| 저장소 | 스타(2026-09-15) | 교정 기능 |
| --- | --- | --- |
| NomaDamas/k-skill | 7,558 | `korean-humanizer`(프롬프트만 씀), `korean-spell-check`(외부 검사기) |
| epoko77-ai/im-not-ai | 5,546 | `humanize-korean` |
| sangrokjung/claude-forge | 836 | `humanize-korean` |
| devswha/patina | 357 | 윤문 |
| DaleSeo/korean-skills | 199 | `humanizer`, `grammar-checker`, `style-guide` |
| JangHyun-bin/korean-report-skills | 74 | 문장 표현 보완 |
| JellyBrick/korean-prose-skill | 20 | 작성과 교정 |
| amondnet/yoonmoon | 13 | 윤문과 탐지 |
| limleesol/stop-slop-ko | 7 | AI 문체 제거 |

`korean-spell-check` 는 대량 측정에서 뺍니다. k-skill 문서가 그 검사기를 「사용자 주도 저빈도 교정 용도로만」 쓴다고 적었고, 검사기의 옛 판이 「비상업적 용도」, 「개인이나 학생만 무료」라고 안내한다고 적었기 때문입니다[\[R7\]](#r7).

### 6.3 지표

사용자가 정한 두 목표를 지표로 옮겼습니다.

**「의미가 절대 손실되지 않는 명확한 한국어 표현」**

- **사실 목록이 붙은 입력:** 상시 적용 쪽에는 반드시 담아야 할 사실을 적은 요청문을 줍니다. 교정 쪽에는 사실 목록을 미리 뽑아 둔 원문을 줍니다.
- **의미 손실:** 사라진 사실, 바뀐 사실, 새로 생긴 사실, 빠진 문장 성분을 셉니다. 판정은 `docs/experiments/detail-retention/analyze.py` 의 판정 항목(missing·weakened·added·omitted)을 다시 씁니다. 손실이 1건이라도 있으면 탈락입니다.
- **명확성:** 문장마다 주어나 지시 대상이 모호한 곳을 셉니다.

**「번역체 교정, AI 표현 최소화」**

- **AI 신호 밀도:** [5. 분석 방법](#5-분석-방법) 분석 도구의 점수를 1,000자당으로 셉니다. 사람 글의 값을 기준선으로 함께 적습니다.
- **변경률:** 교정 도구가 원문을 얼마나 바꿨는지 기록해 과하게 고친 경우를 가려냅니다.

판정자는 claude-opus-5 이고 순서를 바꿔 두 번 묻습니다. 판정 결과의 일부는 사람이 원문과 대조합니다.

### 6.4 판정 순서

1. 의미 손실 0건인 것만 남깁니다.
2. 남은 것을 AI 신호 밀도가 낮은 순으로 줄 세웁니다.
3. 밀도가 같으면 명확성으로 가립니다.

상시 적용 쪽은 같은 요청문에 플러그인만 바꾸고, 아무것도 켜지 않은 기준선을 함께 잽니다. 교정 쪽은 [4.2 AI 글](#42-ai-글) 의 AI 글 가운데 일부를 같은 입력으로 씁니다.

### 6.5 실행 장비에서 먼저 확인할 것

플러그인마다 격리해 설치하고 실행하는 스크립트가 필요합니다. 이 저장소의 이전 측정에서 `--plugin-dir` 로 올린 output style 은 `--setting-sources` 를 세 가지로 바꿔도 적용되지 않았습니다(EVALUATION.md M절 「이 측정이 못 보는 것」 5번)[\[R1\]](#r1). 그래서 스타일이 실제로 켜졌는지를 먼저 확인하는 절차를 둡니다.

## 7. 진행 순서

### 7.1 단계

0. 이 문서를 결과보다 먼저 커밋합니다.
1. **연구 수집:** 2026-09-15 에 1차로 마쳐 [5.2 후보 패턴과 근거 상태](#52-후보-패턴과-근거-상태) 에 반영했습니다. 원문을 열지 못한 연구는 [10.3 2차 인용(원문을 아직 열지 않음)](#103-2차-인용원문을-아직-열지-않음) 에 남아 있습니다.
2. **파일럿:** [4.3 파일럿](#43-파일럿) 을 돌립니다.
3. **본 표본 수집:** [4.1 사람 글](#41-사람-글) 과 [4.2 AI 글](#42-ai-글) 를 모읍니다.
4. **분석:** 등급과 문턱을 정하고 검증용 표본으로 확인합니다.
5. **플러그인 조사와 측정:** [6. 플러그인 비교 방법](#6-플러그인-비교-방법) 을 돌립니다.
6. **기록:** 결과와 채택 이유를 이 문서에 적습니다.

### 7.2 사람이 확인하는 지점

- 표본 목록(URL, 게시일)이 확정됐을 때
- 파일럿 결과가 나왔을 때
- 본 실행 결과가 나왔을 때
- 표본 20편이 사람 글인지 사용자가 직접 확인하고, LLM 판정의 일부를 원문과 대조합니다.

### 7.3 비용 승인

본 실행(AI 글 생성 1,500회, 플러그인 측정, 판정)은 파일럿 뒤에 승인받습니다. 파일럿에서 잰 호출당 비용과 시간으로 견적을 내어 함께 보고합니다.

## 8. 이미 확인한 사실(직접 실험, 2026-09-15)

### 8.1 위키백과 옛 판을 받을 수 있다

「웹 브라우저」 문서의 2022-11-30 이전 마지막 판을 API 로 조회했습니다.

```bash
curl "https://ko.wikipedia.org/w/api.php?action=query&prop=revisions&titles=웹_브라우저&rvlimit=1&rvstart=2022-11-30T00:00:00Z&rvdir=older&rvprop=ids|timestamp&format=json"
```

판 번호 33640764, 저장 시각 2022-11-13T00:00:48Z 가 나왔습니다. 이 판을 `action=parse&oldid=33640764` 로 받아 `<p>` 문단만 뽑으니 한글 1,085자였습니다. 무작위 문서 목록(`list=random&rnnamespace=0`)도 조회됐습니다.

### 8.2 im-not-ai 코퍼스는 받을 수 없다

- im-not-ai 저장소의 `docs/en/evidence.md` 에 다음 문장이 있습니다(`gh api repos/epoko77-ai/im-not-ai/contents/docs/en/evidence.md` 로 확인).

  > "The corpora themselves are not committed here for copyright reasons; method and results are."
  >
  > 번역: 코퍼스 자체는 저작권 때문에 여기에 커밋하지 않았다. 방법과 결과만 있다.

- 재현 경로로 적힌 `imnotai-web` 저장소는 `gh repo view epoko77-ai/imnotai-web` 에서 「Could not resolve to a Repository」로 조회되지 않았습니다.

### 8.3 기술 블로그 목록과 게시일

사이트맵을 받아 `<loc>` 개수를 셌습니다.

| 주소 | HTTP | `<loc>` 수 |
| --- | --- | --- |
| tech.kakao.com/sitemap.xml | 200 | 520 |
| hyperconnect.github.io/sitemap.xml | 200 | 312 |
| tech.socarcorp.kr/sitemap.xml | 200 | 256 |
| d2.naver.com/sitemap.xml, techblog.yogiyo.co.kr/sitemap.xml | 200 | 0 |
| techblog.woowahan.com, engineering.linecorp.com/ko, helloworld.kurly.com | 403 | 0 |
| toss.tech, tech.kakaopay.com, blog.banksalad.com | 404 | 0 |

사이트맵이 막힌 곳은 1단계에서 RSS 나 목록 페이지로 글 주소를 모읍니다. 게시일이 페이지에 적히는지는 우아한형제들 「검색을 위한 데이터 다루기」(techblog.woowahan.com/2718)로 확인했고 2021-03-02 였습니다. 이 확인은 WebFetch 요약으로 한 것이라, 본 수집에서는 원문 HTML 에서 날짜를 다시 뽑습니다.

### 8.4 Wayback Machine 은 이날 쓸 수 없었다

`https://web.archive.org/cdx/search/cdx?url=techblog.woowahan.com/2718/` 요청이 HTTP 503 과 「Internet Archive: Temporarily Offline」 페이지를 돌려줬습니다. 그래서 게시일을 보관본으로 한 번 더 대조하는 절차는 넣지 않았습니다. 다시 열리면 표본 일부에 대조를 더합니다.

### 8.5 도구

- `trafilatura` 2.2.0 을 스크래치 폴더의 가상 환경에 설치했습니다.
- PyPI 에 `kiwipiepy` 0.23.2(「Kiwi, the Korean Tokenizer for Python」)가 있습니다.
- 2026-09-16: 같은 가상 환경(Python 3.13.7)에 `kiwipiepy` 0.23.2, spaCy 3.8.16 과 `ko_core_news_sm` 3.8.0, SciPy 1.18.1, PyYAML 6.0.3 을 설치했습니다. `ko_core_news_sm` 의 파이프라인에 `parser` 가 있고, 예문 「점검 장치 때문에 장비가 계속 멈췄습니다.」에서 어절마다 의존 관계(`obl`, `advmod` 등)와 지배어 위치가 나오는 것을 확인했습니다.

### 8.6 Neyman-Pearson 표본 수 계산

```bash
python3 -c "import math;print(math.ceil(math.log(0.05)/math.log(1-0.01)))"   # 299
python3 -c "print(1-0.05**(1/150))"                                        # 0.0198...
```

같은 식에 논문의 예(α = 0.05, δ = 0.05)를 넣으면 59가 나와 논문의 값과 같습니다[\[S2\]](#s2).

### 8.7 Wayback 대신 Common Crawl

2026-09-16 에 세 요청을 보냈습니다.

```bash
curl 'https://web.archive.org/cdx/search/cdx?url=techblog.woowahan.com/2718/&limit=2&output=json'
curl 'https://index.commoncrawl.org/collinfo.json'
curl 'https://index.commoncrawl.org/CC-MAIN-2022-49-index?url=velog.io/@velopert/*&output=json&limit=3'
```

첫 요청은 26초 뒤 「Internet Archive: Temporarily Offline」 쪽을 돌려줬습니다. 둘째 요청은 수집 목록 127개를 돌려줬고, 이름에 2022 가 든 수집은 6개였습니다. 셋째 요청은 글마다 수집 시각(`timestamp`), 상태, 언어(`kor,eng`), WARC 파일과 위치가 담긴 줄을 돌려줬습니다. 수집기(`collect_cc.py`)는 CC-MAIN-2022-40, 2022-33, 2022-21 을 차례로 찾고, 수집 시각이 기준일보다 앞선 줄만 씁니다.

### 8.8 생성 호출

`claude -p "한 문장으로 자기소개를 하세요." --model claude-sonnet-5 --tools "" --setting-sources "" --strict-mcp-config --no-session-persistence --max-turns 1 --output-format json` 한 번이 오류 없이 끝났고 비용은 0.0249달러였습니다. 답이 「저는 Claude Code로, 소프트웨어 엔지니어링 작업을 돕기 위해 만들어진 AI 에이전트입니다.」였으므로 Claude Code 의 기본 시스템 프롬프트가 실린 상태입니다.

## 9. 알려진 약점

1. **사람 글의 대표성:** 위키 글은 여러 사람이 고친 글이고 기술 블로그 글은 사내 검수를 거친 글이라 개인 문체를 대표하지 못합니다. 번역기의 도움을 받은 글이 섞였는지는 확인하지 않았습니다.
2. **AI 글의 현실성:** 같은 주제로 쓰게 한 글은 실제 작업 중에 나오는 README 나 보고서와 다를 수 있고, 프롬프트에 따라 결과가 달라집니다.
3. **판정자 편향:** 의미 손실과 명확성을 Claude 가 판정하므로 Claude 가 쓴 글을 Claude 가 채점하는 구조입니다. 사람 대조로 일부만 줄입니다.
4. **도구의 정확도:** 형태소 분석기가 틀리면 띄어쓰기와 품사 지표가 함께 틀립니다.
5. **목표끼리의 충돌:** 사람 글 0건과 검출력이 서로 당겨서 남는 패턴이 거의 없을 수 있습니다. 그 경우의 처리는 미리 정하지 않았으므로 사후 조정의 위험이 남습니다([5.6 결과가 「가를 수 없다」일 때](#56-결과가-가를-수-없다일-때)).
6. **조사의 한계:** output style 플러그인을 모두 찾았다고 보장할 수 없습니다([6.1 output style 플러그인 조사](#61-output-style-플러그인-조사)).
7. **장르 전이:** KatFishNet 은 에세이, 시, 논문 초록으로 쟀습니다[\[S1\]](#s1). 기술 문서에서 같은 방향이 나오리라는 보장이 없고, 이 저장소의 관찰에서는 쉼표 방향이 반대였습니다[\[R3\]](#r3).
8. **블로그 날짜:** Common Crawl 수집 시각은 게시일의 상한일 뿐이므로, 2022-11-30 전에 쓰였다는 것만 보장하고 정확한 게시일은 모릅니다([8.7 Wayback 대신 Common Crawl](#87-wayback-대신-common-crawl)).
9. **근거의 언어와 대상:** 한국어 AI 글을 다룬 심사 연구는 두 편이고, 하나는 에세이·시·논문 초록을, 다른 하나는 AI 를 활용한 대학생 과제물 69편을 다뤘습니다. 나머지 근거는 영어·일본어 LLM 글이나 한국어 번역문 연구라서, 우리 장르의 한국어 LLM 글에서 같은 방향이 나온다는 보장이 없습니다(5.2). 영어·일본어의 문법 특징을 한국어 표지로 옮기는 과정(예: 명사화, 조동사, 구 패턴)에도 판단이 들어갑니다.
10. **표본 틀의 치우침:** 개인 블로그 표본 틀이 개발자 블로그 목록이라 주제가 개발에 치우칩니다. Common Crawl 에 수집된 글만 쓰므로 자주 수집되는 블로그 쪽으로도 치우칠 수 있습니다.
11. **정한 값의 근거:** 로그 오즈 사전분포의 α0 = 1,000, MATTR 창 100, 인식 표지·담화 표지·완화어 목록은 이 분석이 정한 값이고 출처가 없습니다.

## 10. 출처

S1~S23 은 2026-09-15 에 열어 확인했습니다. S24·S25 와, S1·S12·S13·S14·S16·S21 에 더한 인용과 수치, 그리고 S26 은 2026-09-16 에 원문을 열어 확인했습니다.

### 10.1 논문과 공개 자료

<a id="s1"></a>**[S1]** Park, Kim, Kim, Han. *KatFishNet: Detecting LLM-Generated Korean Text through Linguistic Feature Analysis.* ACL 2025. [arXiv 2503.00032](https://arxiv.org/abs/2503.00032), 본문 [HTML v3](https://arxiv.org/html/2503.00032v3). 데이터는 에세이, 시, 논문 초록이고 LLM 은 GPT-4o, Solar, Qwen2, Llama3.1 입니다.

> "LLMs include commas in more sentences and uses them more frequently"
>
> 번역: LLM 은 더 많은 문장에 쉼표를 넣고 더 자주 쓴다.

> "LLMs tend to place commas later in a sentence than humans."
>
> 번역: LLM 은 사람보다 문장의 더 뒤쪽에 쉼표를 두는 경향이 있다.

> "LLMs strictly follow spacing rules, while human writers omit spaces due to stylistic and grammatical factors."
>
> 번역: LLM 은 띄어쓰기 규칙을 엄격하게 따르지만, 사람은 문체와 문법상의 이유로 띄어쓰기를 생략한다.

> "Humans tend to use a more diverse range of POS combinations in their writing compared to LLMs."
>
> 번역: 사람은 LLM 보다 더 다양한 품사 조합을 쓰는 경향이 있다.

> "KatFishNet with comma usage patterns outperforms all other methods across all three text genres"
>
> 번역: 쉼표 사용 패턴을 쓴 KatFishNet 이 세 장르 모두에서 다른 모든 방법보다 성능이 높다.

본문 표 2 는 에세이에서 쉼표 사용률 사람 1.13%·LLM 2.56%, 쉼표의 상대 위치 0.09·0.18, 쉼표로 나뉜 구간 길이 4.35·8.56, 쉼표 앞뒤 품사 쌍 다양성 24.38·59.39 를 보고합니다. 부록 L 은 어휘 분포를 Zipf·Heaps 법칙으로 비교했습니다.

> "LLMs tend to use a narrower range of vocabulary and frequently repeat specific word patterns when writing, unlike humans who typically show greater lexical diversity."
>
> 번역: LLM 은 글을 쓸 때 더 좁은 범위의 어휘를 쓰고 특정 단어 패턴을 자주 되풀이한다. 사람은 대체로 어휘 다양성이 더 크다.

부록 E 는 시와 논문 초록의 품사 n-gram 다양성도 보고합니다.

> "Excluding POS 4-gram and 5-gram in poetry, human-written text shows a higher diversity score than LLM-generated text."
>
> 번역: 시의 품사 4-gram 과 5-gram 을 빼면, 사람이 쓴 글의 다양성 점수가 LLM 이 생성한 글보다 높다.

<a id="s2"></a>**[S2]** Tong, Feng, Li. *Neyman-Pearson classification algorithms and NP receiver operating characteristics.* Science Advances, 2018. [PMC5804623](https://pmc.ncbi.nlm.nih.gov/articles/PMC5804623/)

> "we need to have the minimum sample size requirement n ≥ log δ/ log(1 − α)"
>
> 번역: 최소 표본 수 조건 n ≥ log δ / log(1 − α) 를 만족해야 한다.

같은 논문은 α = 0.05, δ = 0.05 일 때 최소 표본 수를 59로 제시합니다. 1종 오류는 「class 0 관측을 class 1 로 잘못 분류할 조건부 확률」로 정의되며, 이 분석에서 class 0 은 사람 글입니다.

<a id="s3"></a>**[S3]** Monroe, Colaresi, Quinn. *Fightin' Words: Lexical Feature Selection and Evaluation for Identifying the Content of Political Conflict.* Political Analysis 16(4), 2008. [PDF](https://languagelog.ldc.upenn.edu/myl/Monroe.pdf)

> "The problem is clearly that the estimates for infrequently spoken words have higher variance than frequently spoken ones."
>
> 번역: 문제는 분명히, 드물게 쓰인 단어의 추정치가 자주 쓰인 단어의 추정치보다 분산이 크다는 데 있다.

> "Specifically, we will use as the evaluation measure the z-scores of the log-odds-ratios"
>
> 번역: 구체적으로, 평가 척도로 로그 오즈비의 z 점수를 쓴다.

3.5.1절의 제목이 「Informative Dirichlet prior」(정보가 있는 디리클레 사전분포)입니다.

<a id="s4"></a>**[S4]** Mosteller & Wallace, *Inference and Disputed Authorship: The Federalist* 에 대한 서평. S. K. Khamis, Review of the International Statistical Institute 34(2), 1966, pp. 277-279. [PDF](http://www2.stat.duke.edu/courses/Fall07/sta103/Federalist.pdf). 원서가 아니라 서평을 열어 확인했습니다.

> "the rates of usage of a word in a block of 200 words to which each paper has been divided are used as variables"
>
> 번역: 각 논설을 200단어 단위로 나눈 구간에서의 단어 사용률을 변수로 쓴다.

> "The authors are not satisfied by the use of a single word or a few words to assist in the identification of authorship, but rather as many words and clues which together lead to "overwhelming" evidence, as no single word or clue is satisfactory"
>
> 번역: 저자들은 한 단어나 몇 단어로 저자를 가리는 데 만족하지 않고, 함께 모여 「압도하는」 증거가 되는 많은 단어와 단서를 쓴다. 어떤 단어나 단서도 혼자서는 충분하지 않기 때문이다.

> "the final odds, that is the product of initial odds and the likelihood ratio, which is rendered additive by resorting to log odds"
>
> 번역: 최종 오즈는 초기 오즈와 우도비의 곱이며, 로그 오즈를 써서 덧셈으로 바꾼다.

서평은 원서가 로그 오즈에 「상관과 그 밖의 요인을 반영하는 조정(adjustments made to log odds to take account of correlation)」을 했다고 적습니다.

<a id="s5"></a>**[S5]** Kobak, González-Márquez, Horvát, Lause. *Delving into LLM-assisted writing in biomedical publications through excess vocabulary.* Science Advances, 2025. [arXiv 2406.07016](https://arxiv.org/abs/2406.07016)

> "the appearance of LLMs led to an abrupt increase in the frequency of certain style words"
>
> 번역: LLM 의 등장이 특정 스타일 단어의 빈도를 갑자기 늘렸다.

> "at least 13.5% of 2024 abstracts were processed with LLMs"
>
> 번역: 2024년 초록의 적어도 13.5%가 LLM 을 거쳐 작성됐다.

<a id="s6"></a>**[S6]** Hanley & Lippman-Hand. *If Nothing Goes Wrong, Is Everything All Right? Interpreting Zero Numerators.* JAMA 249(13), 1983, pp. 1743-1745. [저자 사이트 PDF](https://jhanley.biostat.mcgill.ca/c607/ch08/zero_numerator.pdf)

> "if none of n patients shows the event about which we are concerned, we can be 95% confident that the chance of this event is at most three in n (ie, 3/n)"
>
> 번역: n 명의 환자 중 걱정하는 사건이 한 명에게도 나타나지 않았다면, 그 사건의 확률이 n 분의 3(즉 3/n) 이하라고 95% 확신할 수 있다.

<a id="s7"></a>**[S7]** 영어 위키백과 「ChatGPT」 문서 요약(2차 자료). OpenAI 공지 페이지(openai.com/index/chatgpt)는 403 으로 열리지 않아 위키백과 API 로 확인했습니다.

> "Originally released on November 30, 2022"
>
> 번역: 2022년 11월 30일에 처음 공개됐다.

<a id="s8"></a>**[S8]** Liang, Yuksekgonul, Mao, Wu, Zou. *GPT detectors are biased against non-native English writers.* Patterns, 2023. [arXiv 2304.02819](https://arxiv.org/abs/2304.02819)

> "detectors consistently misclassify non-native English writing samples as AI-generated, whereas native writing samples are accurately identified"
>
> 번역: 탐지기는 비원어민이 쓴 영어 글을 일관되게 AI 생성으로 잘못 분류했고, 원어민이 쓴 글은 정확히 식별했다.

> "GPT detectors may unintentionally penalize writers with constrained linguistic expressions"
>
> 번역: GPT 탐지기는 언어 표현이 제한된 필자에게 의도치 않게 불이익을 줄 수 있다.

<a id="s9"></a>**[S9]** Park, Han. *From Intuition to Calibrated Judgment: A Rubric-Based Expert-Panel Study of Human Detection of LLM-Generated Korean Text.* arXiv 2601.19913, 2026(심사 전). [arXiv](https://arxiv.org/abs/2601.19913)

> "Three Korean language and literature majors used a 16-criterion, 100-point rubric to score six student essays and 24 essays from four LLMs prompted for three school levels."
>
> 번역: 국어국문학 전공자 세 명이 16개 기준, 100점 만점 채점표로 학생 글 6편과, 세 학교급을 지정해 네 LLM 이 쓴 글 24편을 채점했다.

> "The pooled LLM mean exceeds the student mean by 18.35 points. Orthographic norms and genre-appropriate register contribute 8.19 points, or 44.7% of the gap."
>
> 번역: LLM 글 전체 평균이 학생 글 평균보다 18.35점 높다. 정서법 규범과 장르에 맞는 격식이 8.19점, 곧 그 차이의 44.7%를 차지한다.

이 자료는 심사 전이라 후보를 만드는 데 쓰지 않고 보조 근거로만 씁니다.

<a id="s10"></a>**[S10]** Zaitsu, Jin. *Distinguishing ChatGPT(-3.5, -4)-generated and human-written papers through Japanese stylometric analysis.* PLOS ONE, 2023. [PMC10411719](https://pmc.ncbi.nlm.nih.gov/articles/PMC10411719/). 사람 학술문 72편, GPT-3.5 글 72편, GPT-4 글 72편을 품사 bigram, 조사 bigram, 쉼표 위치, 기능어 비율로 비교했습니다. 기능어 비율만 쓴 분류기의 정확도가 「98.1%」, 모든 특징을 합친 분류기가 「100%」였습니다.

<a id="s11"></a>**[S11]** Zaitsu 외. *Stylometry can reveal artificial intelligence authorship, but humans struggle: A comparison of human and seven large language models in Japanese.* PLOS ONE, 2025. [PMC12558491](https://pmc.ncbi.nlm.nih.gov/articles/PMC12558491/). 사람 글 100편과 7개 모델(GPT-4o, o1, Claude 3.5, Gemini, Copilot, Llama 3.1, Perplexity) 글 350편을 비교했습니다.

> "function word unigrams, POS bigrams, and phrase patterns"
>
> 번역: 기능어 unigram, 품사 bigram, 구 패턴

이 세 특징을 합친 분류기가 「99.8%」였고, 사람 참가자는 사람이 쓴 글을 31.5%만 사람 글로 맞혔습니다.

<a id="s12"></a>**[S12]** Muñoz-Ortiz, Gómez-Rodríguez, Vilares. *Contrasting Linguistic Patterns in Human and LLM-Generated News Text.* Artificial Intelligence Review 57, 265, 2024. [arXiv 2308.09067](https://arxiv.org/abs/2308.09067)

> "Human texts exhibit more scattered sentence length distributions, more variety of vocabulary"
>
> 번역: 사람이 쓴 글은 문장 길이 분포가 더 흩어져 있고 어휘가 더 다양하다.

> "LLM outputs use more numbers, symbols and auxiliaries (suggesting objective language) than human texts, as well as more pronouns"
>
> 번역: LLM 출력은 사람 글보다 숫자, 기호, 조동사를 더 쓰고(객관적인 언어를 뜻함) 대명사도 더 쓴다.

본문(Artificial Intelligence Review 판 PDF)에서 확인한 내용입니다.

> "humans exhibit a preference for using certain kinds of content words, such as nouns and adjectives. Humans also use punctuation symbols more often (except when compared to Falcon)"
>
> 번역: 사람은 명사와 형용사 같은 내용어를 선호한다. 사람은 문장부호도 더 자주 쓴다(Falcon 과 비교할 때는 예외).

> "This may result in less variation and more uniform sentence lengths in LLM-generated text"
>
> 번역: 그래서 LLM 이 생성한 글은 문장 길이의 변화가 적고 더 균일할 수 있다.

> "syntactic structures from LLMs exhibit significantly fewer subtrees involving adjective modifiers (amod dependency type) and appositional modifiers (appos)."
>
> 번역: LLM 의 통사 구조에는 형용사 수식어(amod)와 동격 수식어(appos)를 포함한 하위 구조가 유의하게 적다.

> "language models use a considerably larger amount of subordinate clauses (SBAR)."
>
> 번역: 언어 모델은 종속절(SBAR)을 상당히 더 많이 쓴다.

> "all tested LLMs choose word orders that optimize dependency lengths to a lesser extent than humans; while they have a tendency to use more auxiliary verbs and verb phrases and less noun and prepositional phrases."
>
> 번역: 시험한 모든 LLM 은 사람보다 의존 거리를 덜 최적화하는 어순을 고르고, 조동사와 동사구를 더 쓰며 명사구와 전치사구를 덜 쓰는 경향이 있다.

> "the models tested manifested less propensity than humans for displaying aggressive negative emotions, such as fear or anger."
>
> 번역: 시험한 모델은 공포나 분노 같은 공격적인 부정 감정을 사람보다 덜 드러냈다.

<a id="s13"></a>**[S13]** Herbold, Hautli-Janisz, Heuer, Kikteva, Trautsch. *A large-scale comparison of human-written versus ChatGPT-generated essays.* Scientific Reports 13, 18617, 2023(서지는 Europe PMC 로 확인). [arXiv 2304.14276](https://arxiv.org/abs/2304.14276)

> "The writing style of the AI models exhibits linguistic characteristics that are different from those of the human-written essays, e.g., it is characterized by fewer discourse and epistemic markers, but more nominalizations and greater lexical diversity."
>
> 번역: AI 모델의 문체는 사람이 쓴 에세이와 다른 언어적 특징을 보인다. 예를 들어 담화 표지와 인식 표지가 적고, 명사화가 많고 어휘 다양성이 크다.

본문 HTML 의 결과 표에서 확인한 값입니다(사람, ChatGPT-3, ChatGPT-4 순). 어휘 다양도 MTLD 95.72·75.68·108.91, 문장당 절 수 1.81·2.31·2.08, 명사화 1.06·1.56·1.73, 양태 표현 10.84·8.97·6.12, 인식 표지 0.06·0.02·0.00, 담화 표지는 사람 0.57 과 ChatGPT-4 0.36 사이에서 유의한 차이가 있었습니다.

<a id="s14"></a>**[S14]** Reinhart, Markey, Laudenbach, Pantusen, Yurko, Weinberg, Brown. *Do LLMs write like humans? Variation in grammatical and rhetorical styles.* PNAS 122, 2025. [arXiv 2410.16107](https://arxiv.org/abs/2410.16107), 본문 [HTML](https://arxiv.org/html/2410.16107)

> "the instruction-tuned LLMs used present participial clauses at 2 to 5 times the rate of human text"
>
> 번역: 지시 조정된 LLM 은 현재분사절을 사람 글의 2~5배 비율로 썼다.

> "They also use nominalizations at 1.5 to 2 times the rate of humans"
>
> 번역: 명사화도 사람의 1.5~2배 비율로 쓴다.

> "GPT-4o uses the agentless passive voice at roughly half the rate as human texts"
>
> 번역: GPT-4o 는 행위자 없는 수동태를 사람 글의 절반쯤 되는 비율로 쓴다.

> "'that' clauses as subject 2.6 times as often"
>
> 번역: 주어 자리의 that 절을 2.6배 자주 쓴다.

> "phrasal coordination 1.9 times as often"
>
> 번역: 구 단위 등위 접속을 1.9배 자주 쓴다.

> "both GPT-4o models use downtoners (such as barely or nearly) more frequently than humans"
>
> 번역: GPT-4o 두 모델은 barely 나 nearly 같은 완화어를 사람보다 자주 쓴다.

<a id="s15"></a>**[S15]** Juzek, Ward. *Why Does ChatGPT "Delve" So Much? Exploring the Sources of Lexical Overrepresentation in Large Language Models.* COLING 2025. [arXiv 2412.11385](https://arxiv.org/abs/2412.11385)

> "21 focal words whose increased occurrence in scientific abstracts is likely the result of LLM usage"
>
> 번역: 과학 초록에서 늘어난 출현이 LLM 사용의 결과로 보이는 초점 어휘 21개

> "While the model testing is consistent with RLHF playing a role, our experimental results suggest that participants may be reacting differently to 'delve' than to other focal words."
>
> 번역: 모델 실험 결과는 RLHF 가 원인의 하나라는 설명과 맞지만, 실험 결과를 보면 참가자들이 'delve' 에는 다른 초점 어휘와 다르게 반응했을 수 있다.

<a id="s16"></a>**[S16]** Toral. *Post-editese: an Exacerbated Translationese.* Machine Translation Summit XVII, 2019. [arXiv 1907.00900](https://arxiv.org/abs/1907.00900)

> "PEs are simpler and more normalised and have a higher degree of interference from the source language than HTs."
>
> 번역: 후편집 번역은 사람이 처음부터 한 번역보다 더 단순하고 더 정규화돼 있으며 원천 언어의 간섭이 더 크다.

> "PEs have lower lexical variety and lower lexical density than HTs."
>
> 번역: 후편집 번역은 사람 번역보다 어휘 다양도와 어휘 밀도가 낮다.

<a id="s17"></a>**[S17]** El Attar, Dönmez, Maurer, Falenska. *A Systematic Analysis of Linguistic Features in AI-Generated Text Detection Across Domains and Models.* arXiv 2606.04177, 2026(심사 전). [arXiv](https://arxiv.org/abs/2606.04177). 해석 가능한 언어 특징 284개를 27개 LLM, 10개 영역에서 비교했습니다.

> "measures of lexical richness, which remain robust signals across model families and text domains"
>
> 번역: 어휘 풍부도 척도는 모델 계열과 텍스트 영역이 달라져도 강한 신호로 남는다.

> "many previously proposed indicators prove strongly context-dependent"
>
> 번역: 앞서 제안된 지표 가운데 많은 수가 맥락에 크게 좌우되는 것으로 드러났다.

이 자료는 심사 전이라 후보를 만드는 데 쓰지 않고 보조 근거로만 씁니다.

<a id="s18"></a>**[S18]** Freeburg. *The Last Fingerprint: How Markdown Training Shapes LLM Prose.* arXiv 2603.27006, 2026(심사 전). [arXiv](https://arxiv.org/abs/2603.27006). 5개 회사의 12개 모델을 쟀고, 초록에 사람 글과의 비교는 없습니다.

> "from 0.0 per 1,000 words (Llama) to 9.1 (GPT-4.1 under suppression)"
>
> 번역: 1,000단어당 0.0(Llama)부터 9.1(억제 지시를 받은 GPT-4.1)까지

이 자료는 심사 전이라 후보를 만드는 데 쓰지 않고 보조 근거로만 씁니다.

<a id="s19"></a>**[S19]** 최희경. 「번역투 다시 보기: 코퍼스 분석 사례를 토대로」. 『번역학연구』 17(1), 2016. [KCI PDF](https://journal.kci.go.kr/kats/archive/articlePdf?artiId=ART002094440). 표 4에서 `~통하다` 의 빈도가 번역 기사문(41,578어절) 35회, 비번역 기사문(75,793어절) 128회, 일반 문어 참조 코퍼스(36,942,784어절) 37,575회입니다. 표의 정규화 빈도 42.090, 84.441, 50.856 은 5만 어절당 값입니다(`35/41578*50000` 등으로 다시 계산해 일치를 확인). 논문은 이렇게 적습니다.

> 「비번역에서 '~통하다'라는 표현이 번역에서보다 2배 이상 높을 뿐 아니라 일반적인 한국어 문어 텍스트보다도 크게 높아 해당 장르의 텍스트를 생산한 언어화자들에게 이 표현이 '어색하거나 잘못된 번역투'로 인식되지 않는다는 점을 방증한다.」

<a id="s20"></a>**[S20]** 최희경. 「코퍼스 분석에 기반한 한국어 기사문 번역과 비번역의 문체 비교 연구」. 『통역과 번역』 18(1), 231-255쪽, 2016. [KCI](https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART002099612)

> "stylistic differences between translated and non-translated news articles in such stylistic features as average sentence length, demonstratives, conjunctions, and direct and indirect quotations"
>
> 번역: 평균 문장 길이, 지시어, 접속어, 직접·간접 인용 같은 문체 특징에서 번역 기사문과 비번역 기사문 사이의 문체 차이

<a id="s21"></a>**[S21]** 김정우. 「현대 국어 번역문의 실태」. 『새국어생활』 22(1), 국립국어원, 2012. [PDF](https://www.korean.go.kr/nkview/nklife/2012_1/22_0104.pdf). 김혜영(2009)이 번역 텍스트와 비번역 텍스트를 각각 100만 어절 규모의 형태 분석 말뭉치로 비교한 결과를 요약한 글입니다. 김혜영(2009) 원문은 열지 않았으므로 이 요약을 근거로 씁니다.

> 「체언에서는 1인칭 대명사의 빈도가 낮고 2인칭과 3인칭 대명사의 빈도가 높은데」
>
> 「의존 명사는 '것/거'와 '때문'이 많이 쓰인다. 용언에서는 '만들다, 가지다, 의하다, 대하다' 등의 동사가 많이 나타나고, 통사적 피동에 사용되는 '-아/어 지다' 형태가 많이 나타난다.」
>
> 「또 피동 표현 자체가 (비번역문에 비해) 많이 나타나고 '-에 의하여'를 행위자로 하는 피동 표현이 두드러진다.」
>
> 「품사별 빈도에서 정보성이 낮고 어휘의 다양성이 낮아서 단순화의 특징을 보여 주고」

표 5.2 의 나머지 번역문 특징은 같은 글의 아래 문장에서 가져왔습니다. PDF 의 줄바꿈과 쪽 머리글은 이어 붙였습니다.

> 「수식언에서는 단형 부정문에 사용되는 부사 '안, 못'이 적게 나타나고, 정도 부사 '가장, 매우, 아주, 너무'가 많이 나타난다. 접속 부사 '및, 혹은, 그런데, 한편'이 적게 나타나고, '그리고, 그러나, 하지만, 왜냐하면'이 많이 나타난다.」
>
> 「관계언(조사)에서는 주격 조사 '-이/가'의 빈도가 낮게 나타나고, 관형격 조사 '-의'와 부사격 조사 '-에게서, -으로부터, -으로' 등의 빈도가 높게 나타난다.」
>
> 「그리고 주격 조사 '-이/가'에 비해 주제 표시 보조사 '-은/는'이 과도하게 많이 나타난다.」
>
> 「보조 용언이 결합한 시간 표현('-고 있다', '-아/어 왔다', '-을 것이다' 등)이 선어말 어미에 의한 시간 표현보다 우세하다.」
>
> 「사동 표현에서는 '-게 하다' 혹은 '-게 만들다' 구성에 의한 장형 사동문의 빈도가 높다. 단형 부정이 적으며, '-수 없다'로 표현되는 어휘적 능력 부정 형식이 많이 나타난다.」
>
> 「대등 접속에서는 병렬 접속과 선택 접속의 쓰임이 적고 대조 접속('그러나, 하지만')의 쓰임이 많으며, 그 결과로 전환 접속('그런데')의 쓰임이 현저히 낮다.」
>
> 「그리고 지시 표현에서 3인칭 대명사가 많이 쓰이고 2인칭과 3인칭 대명사는 평칭이 적게 쓰이고 존칭이 많이 쓰인다. 높임 표현에서는 선어말 어미 '-(으)시-'에 의한 주체 존대 형식의 빈도가 낮게 나타난다.」

<a id="s22"></a>**[S22]** 김정우. 「영어 복수 표현의 한국어 번역에 관한 종합적 고찰」. 『번역학연구』 14(4), 2013. [KCI PDF](https://journal.kci.go.kr/kats/archive/articlePdf?artiId=ART001805134). 번역 소설 한 권의 영어 복수 명사 863개(유정명사 154개, 무정명사 709개)가 어떻게 옮겨졌는지 셌습니다. `-들` 을 붙인 유표형은 유정명사 99건, 무정명사 48건이었습니다.

> 「원문의 유정명사가 번역문에서 복수표지 '-들'을 갖는 비율이 무정명사에 비해 월등히 높음(64.3% : 6.8%)을 보여주고 있다.」

<a id="s23"></a>**[S23]** 국립국어원 온라인가나다 답변 두 건. [2025-05-28 답변](https://www.korean.go.kr/front/onlineQna/onlineQnaView.do?mn_id=216&qna_seq=315483&pageIndex=1)은 `-게 되다` 가 피동 표현인지에 대해 문법 학자들 사이에 견해가 갈린다고 답했습니다. [2025-09-24 답변](https://korean.go.kr/front/onlineQna/onlineQnaView.do?mn_id=216&qna_seq=321185&pageIndex=1)은 사동사에 `-어지다` 를 붙여 피동의 뜻을 더할 수 있다고 답했습니다.

> 「사동사가 나타내는 의미에 피동의 의미를 더하기 위해 '-어지다'를 쓸 수도 있습니다.」

<a id="s24"></a>**[S24]** 박종향·김은영. 「생성형 AI 텍스트와 인간 텍스트의 내용 및 문체 비교 연구 －대학 글쓰기의 한계와 가능성」. 『교양교육연구』 19(6), 71-86쪽, 2025. [DOI 10.46392/kjge.2025.19.6.71](https://doi.org/10.46392/kjge.2025.19.6.71)(한국교양교육학회 논문 페이지로 연결됨). 서울 소재 D대학교 교양과목의 2021학년도(생성형 AI 비활용)와 2025학년도(생성형 AI 활용) 학기 말 과제물 69편을 문장 길이, 어휘 다양성(TTR·MATTR), 접속 부사와 연결 표현, 감성 점수로 비교했습니다. 순수한 AI 출력이 아니라 학생이 AI 를 활용해 쓴 글이고, 활용 여부를 학년도로 갈랐다는 한계가 있습니다. 초록은 이렇게 적습니다.

> 「분석 결과, 2025학년도 AI 활용 글은 2021학년도 인간 작성 글보다 문장이 짧고 간결했으며, 어휘 다양성은 전반적으로 낮게 나타났다. 접속 부사의 빈도와 다양성에서는 유의미한 차이가 없었으나, AI 활용 글에서는 조건 접속사 대신 예시⋅강조 접속사가 빈번하게 나타나는 특징이 관찰되었다. 감성 분석에서는 두 집단 간 차이가 드러나지 않았으나,」

<a id="s25"></a>**[S25]** Kendro, Maloney, Jarvis. *Do Large Language Models Produce Texts With "Human-Like" Lexical Diversity? Evidence From Four ChatGPT Models.* International Journal of Applied Linguistics, 2026. DOI 10.1111/ijal.70115(서지는 Crossref 로 확인, 출판사 페이지는 자동 접근이 막혀 열지 못함). 초록은 [arXiv 2508.00086](https://arxiv.org/abs/2508.00086) 에서 확인했습니다. ChatGPT 3.5, 4, o4 mini, 4.5 의 글과 L1·L2 영어 사용자 240명의 글을 어휘 다양도 여섯 차원(volume, abundance, variety-repetition, evenness, disparity, dispersion)으로 비교했습니다.

> "differed significantly from human-written texts for each variable"
>
> 번역: 모든 변수에서 사람이 쓴 글과 유의하게 달랐다.

초록은 ChatGPT-o4 mini 와 ChatGPT-4.5 가 사람과 가장 많이 달랐다고 적습니다. 다만 새 모델의 다양도가 낮기만 한 것은 아닙니다.

> "ChatGPT-4.5 demonstrated higher levels of lexical diversity than older models despite producing fewer tokens"
>
> 번역: ChatGPT-4.5 는 토큰을 더 적게 만들었는데도 옛 모델보다 어휘 다양도가 높았다.

> "the newer models produce less human-like text than older models"
>
> 번역: 새 모델일수록 옛 모델보다 사람 글과 덜 비슷한 글을 만든다.

<a id="s26"></a>**[S26]** Benjamini, Yekutieli. *The control of the false discovery rate in multiple testing under dependency.* The Annals of Statistics 29(4), 1165–1188, 2001. DOI 10.1214/aos/1013699998(서지는 Crossref 로 확인). 본문은 [저자 사이트의 PDF](http://www.math.tau.ac.il/~ybenja/MyPapers/benjamini_yekutieli_ANNSTAT2001.pdf) 에서 확인했습니다. 출판사 쪽은 자동 요청으로 본문이 열리지 않았습니다.

> "For all other forms of dependency, a simple conservative modification of the procedure controls the false discovery rate."
>
> 번역: 그 밖의 모든 형태의 의존에서는, 이 절차를 간단하고 보수적으로 수정한 방법이 거짓 발견률을 통제한다.

### 10.2 저장소 자료

- <a id="r1"></a>**[R1]** `EVALUATION.md` O절(검사 훅 처방과 O3 무효 판단), M절 「이 측정이 못 보는 것」 5번(`--plugin-dir` 로 output style 이 적용되지 않음). 커밋 `b2e2089`.
- <a id="r2"></a>**[R2]** `CLAUDE.md` 「판정 기준을 바꿀 때」: 표지를 표본당 1.95개에서 0.25개로 줄인 판이 블라인드 판정에서 옛 판을 이기지 못했다는 기록.
- <a id="r3"></a>**[R3]** `EVALUATION.md` 「측정 중 고친 것」 28번: 이 컴퓨터의 한국어 `.md` 에서 쉼표 포함률 중앙값이 2023년 이전 문서 41.5%(18편), 2026년 문서 17.6%(152편)로 KatFishNet 과 방향이 반대였다는 기록. 같은 항목에 「띄어쓰기 통계와 품사 n-gram 다양성은 형태소 분석기가 있어야 해서 표준 라이브러리만 쓰는 이 훅에서는 잴 수 없다」고 적혀 있습니다.
- <a id="r4"></a>**[R4]** `plugin/skills/humanize-korean/references/empirical-validation.md`: 대조 코퍼스(사람 60편, AI 60편)의 설계와 한계(27·28·30행), `~를 통해` 기각(62행), 대명사 규칙의 적용 범위(71행). im-not-ai 커밋 9747f03 에서 가져온 파일입니다.
- <a id="r5"></a>**[R5]** `plugin/hooks-handlers/posttooluse.sh` 265~267행: `~에 대해`·`~를 통해` 횟수를 세지 않게 된 실측 기록.
- <a id="r6"></a>**[R6]** `plugin/skills/humanize-korean/references/ai-tell-taxonomy.md`: 심각도 정의(15~17행), 번역학계 계보(5행), 이중 피동 A-8(89행), 부정 대구의 사람 글 532편 재실측(359행), 「오탐 방지 원칙」(786행 이하).
- <a id="r7"></a>**[R7]** k-skill `docs/features/korean-spell-check.md`(`gh api repos/NomaDamas/k-skill/contents/docs/features/korean-spell-check.md` 로 확인).

### 10.3 2차 인용(원문을 아직 열지 않음)

- 김혜영(2009): 번역문과 비번역문 각 100만 어절 비교. 원문을 열지 못해 [\[S21\]](#s21)의 요약만 씁니다.
- 곽은주·진실로(2011) 「텍스트 차원에서의 복수표현의 영한번역전략」(『번역학연구』): 논문이 있다는 것만 검색으로 확인했고 원문은 열지 못했습니다. 번역 전략 논문이라 빈도 근거가 들어 있는지도 모릅니다.
- 이영옥(2001), 김도훈(2009), 김정우(2007), 김혜영(2019), 전영철(2007), 김순영(2012): [\[R6\]](#r6) 규칙집이 인용한 번역학 연구입니다. 원문을 열지 못했습니다.
- 조신(2024) 「인간의 글과 ChatGPT의 글에 대한 텍스트언어학적 접근: TOPIK 쓰기 54번을 중심으로」(『언어와 정보 사회』 51): KCI 소개 페이지에 결과가 적혀 있지 않아 근거로 쓰지 않습니다.

찾지 못하거나 열지 못한 연구는 결론에 쓰지 않습니다.

### 10.4 바로잡은 것

- **KatFishNet 의 품사 다양성:** 웹 검색 결과 요약은 「LLM 이 품사 다양성이 더 크다」고 적었지만, 논문 본문[\[S1\]](#s1)은 품사 n-gram 다양성이 사람 쪽이 더 크다고 적습니다. 요약이 가리킨 값은 쉼표 앞뒤 품사 쌍의 다양성(표 2, LLM 이 높음)으로 보이며, 둘은 서로 다른 지표입니다. 5.2 표에 5번(쉼표 앞뒤 품사 쌍)과 11번(품사 n-gram)으로 나눠 적었습니다.
- **LREAD:** 검색 결과 요약은 「LREAD 틀로 다수결 정확도가 0.60 에서 0.90 으로 올랐다」고 적었지만, 열어 본 arXiv 초록[\[S9\]](#s9)에는 LREAD 라는 이름과 그 수치가 없었습니다. 초록에 있는 내용만 씁니다.
- **국립국어원과 `되어지다`:** 검색 결과 요약은 국립국어원이 「`되어지다` 는 `되다` 로 바꿀 수 있다」고 답했다고 적었지만, 열어 본 답변 두 건[\[S23\]](#s23)에는 그 문장이 없었습니다. 그래서 이 주장은 쓰지 않습니다.

## 11. 파일럿 결과

2026-09-16 에 [4.3 파일럿](#43-파일럿) 을 돌렸습니다. 표본 목록, 제외 목록, 수치 원본은 `docs/experiments/ai-writing-signals/results/pilot/` 에 있습니다. 수집한 본문과 AI 글은 커밋하지 않았습니다.

### 11.1 돌린 것

- **위키 글 10편:** 무작위 문서 126개를 봤습니다. 기준일 전 판이 없던 24개, 동음이의 문서 10개, 한글 800자 미만 82개를 뺐습니다.
- **개인 블로그 글 10편:** 첫 실행이 6편을 모은 뒤 Common Crawl 응답이 끊겨 멈췄고, 이 실행의 통계는 남지 않았습니다. 이어 받은 실행에서는 수집본이 없던 필자 12명, 색인 오류 1명, 800자 미만 글 3편을 건너뛰고 4편을 더 모았습니다.
- **기술 블로그 글 10편:** 표본 틀 86곳 가운데 레진, Amazon Web Services, 무신사, 플라네타리움, 트렌비에서 2편씩입니다. 수집본이 없던 곳이 20곳이었고, 800자 미만이거나 글 쪽 표시가 없어 건너뛴 글이 41편이었습니다.
- **AI 글 30편:** claude-opus-5 와 claude-sonnet-5 가 15편씩 썼습니다. 호출은 59번(Opus 29, Sonnet 30)이었고 비용은 4.04달러(Opus 3.09, Sonnet 0.95)였습니다. 호출 한 번에 Opus 는 0.107달러와 1.1분, Sonnet 은 0.032달러와 0.5분이 들었습니다.

### 11.2 파일럿 중에 고치거나 정한 것

아래는 모두 사람 글과 AI 글의 지표를 비교하기 전에 했습니다. 사전 등록에 없던 결정이므로 따로 적습니다.

1. **수집기 재시도:** 응답이 도중에 끊기는 오류(`IncompleteRead`)를 재시도 대상에 넣고, 재시도 뒤에도 색인이 응답하지 않으면 그 필자를 건너뛰고 기록하게 했습니다.
2. **제목 규칙:** 구분자로 제목을 자르던 규칙이 「새 소식 – AWS OpsWorks for Puppet Enterprise 지원」을 「새 소식」으로 잘랐습니다. `og:title` 을 쓰고 끝이 `og:site_name` 과 같을 때만 떼도록 바꿔, AI 글을 쓰기 전에 제목 3개를 바로잡았습니다.
3. **품사 태그 누락:** Kiwi 는 괄호와 따옴표를 `SSO`·`SSC` 로, 「1.」 같은 글머리를 `SB` 로 태그합니다(kiwipiepy 0.23.2 패키지에 든 `documentation.md` 의 품사 표). 지표 도구가 이 셋을 문장부호나 기호로 보지 않아 고쳤고, 사람 글 지표를 다시 계산했습니다.
4. **생성 실패 제외:** `ai-wiki-05` 는 Opus 가 두 번 모두 「대상을 확실히 알지 못해 쓰면 사실을 지어내게 된다」며 글 대신 자료를 요청했습니다. 비교 대상 글이 아니므로 뺐습니다. 짝인 사람 글은 주 비교에 남겼습니다.
5. **같은 규칙의 정리 단계(`clean.py`):** 제목과 똑같은 줄을 사람 글 5편과 AI 글 9편에서 뺐습니다. 위키 AI 글 한 편에서 미디어위키 제목 줄 5개를 뺐고, AI 글 두 편에서 본문이 아니라 사용자에게 하는 말인 문단(정확도 주의, 작성 예고)을 뺐습니다.

### 11.3 사전 등록 기준으로 낸 결과

- **분포 차이:** 40개 지표 가운데 Benjamini–Yekutieli 보정 뒤 q < 0.05 인 것은 5개입니다(11.4 둘째 표의 왼쪽 네 칸).
- **적중:** 11개 지표가 사람 글 30편의 범위를 벗어난 AI 글을 1편 이상 냈고, AI 글 29편 가운데 21편이 하나 이상에 걸렸습니다. 다른 지표에는 걸리지 않고 한 지표에만 걸린 AI 글은 9편입니다(8번 형태소 MATTR(창 100) 4, 25번 문장 길이 변동계수 1, 28번 1,000형태소당 접속 조사와 '및' 2, 34번 1,000형태소당 완화어 1, 35번 1,000형태소당 가장·매우·아주·너무 1).
- **반분 확인:** 선별용 사람 글 15편의 범위를 문턱으로 삼았을 때 검증용 사람 글이 한 편도 문턱을 넘지 않고 AI 글을 1편 이상 잡은 지표는 5개입니다(1번 쉼표가 든 문장 비율, 8번 형태소 MATTR(창 100), 19번 1,000형태소당 대명사, 26번 문장당 연결어미(보조 용언 앞 제외), 34번 1,000형태소당 완화어). 이 가운데 두 모델과 세 장르에서 방향이 모두 같은 지표는 8번 형태소 MATTR(창 100)입니다.
- **모델 차이:** Opus 와 Sonnet 의 중앙값이 사람 글과 비교해 서로 반대 방향인 지표가 11개였습니다.
- **분량:** AI 글 30편 가운데 목표의 ±20% 안에 든 것은 1편입니다. 목표 대비 비율의 중앙값은 Opus 0.66, Sonnet 0.50 이었고, 한 번 다시 써도 대부분 짧았습니다.

### 11.4 사후 진단

아래 두 진단은 결과를 본 뒤에 정한 것이라 사전 등록 판정이 아닙니다. 11.3 의 결과를 해석하는 데만 씁니다.

**라벨 섞기(`null_check.py`).** 사람/AI 표시를 무작위로 1,000번 섞어 같은 규칙으로 셌습니다.

| 센 것 | 관찰값 | 섞었을 때 중앙값 | 섞었을 때 95번째 백분위 | 섞었을 때 관찰값 이상이 나온 비율 |
| --- | --- | --- | --- | --- |
| 하나 이상의 지표에 걸린 AI 글 수 | 21 | 16 | 21 | 0.07 |
| 전체 적중 수 | 38 | 27 | 43 | 0.13 |
| 반분에서 검증용 사람 글이 0건인 지표 수 | 5 | 7 | 12 | 0.87 |

사람 글의 최댓값·최솟값을 넘는 AI 글은 표시를 섞어도 비슷한 수가 나왔습니다. 지표가 40개이면 우연히 걸리는 글도 그만큼 많기 때문입니다.

**길이 맞춤(`lenmatch.py`).** AI 글이 짧아서 길이에 민감한 지표가 길이 차이를 잰 것일 수 있습니다. 사람 글을 짝이 되는 AI 글의 한글 글자 수에 맞춰 문장 경계에서 자르고 다시 비교했습니다(짝이 없는 `wiki-05` 는 뺌).

| 지표 | 사람 중앙값 | AI 중앙값 | q | 길이 맞춘 사람 중앙값 | 길이 맞춘 q | 연구 방향과 |
| --- | --- | --- | --- | --- | --- | --- |
| 7번 의존명사·보조 용언 앞 띄어쓰기 비율 | 0.855 | 0.944 | 0.00365 | 0.844 | 0.0556 | 같음 |
| 8번 형태소 MATTR(창 100) | 0.694 | 0.73 | 0.000497 | 0.687 | 0.00303 | 표본에서 정함 |
| 11번 품사 1~5-gram 종류÷전체 평균 | 0.399 | 0.455 | 0.0334 | 0.453 | 1 | 반대 |
| 20번 1,000자당 숫자·기호 | 11.5 | 4.78 | 0.0316 | 6.48 | 1 | 반대 |
| 25번 문장 길이 변동계수 | 0.602 | 0.464 | 0.00308 | 0.549 | 0.127 | 같음 |

길이를 맞춘 뒤 q < 0.05 로 남은 지표는 8번 형태소 MATTR(창 100)뿐입니다. 품사 n-gram 다양성의 차이는 사라졌으므로 처음 결과는 길이 차이였던 것으로 봅니다.

### 11.5 판단

1. **도구는 끝까지 돌았습니다.** 수집, 추출, 형태소 분석, 지표 계산, 비교가 모두 돌았고, 도중에 찾은 결함은 11.2 에 적었습니다. 형태소와 띄어쓰기 판정 20문장의 사람 대조(5.1)는 사용자 확인을 기다립니다. 대조표는 `docs/experiments/ai-writing-signals/out/pilot/spotcheck.md` 에 있고 커밋하지 않습니다(사람 글 문장이 들어 있음).
2. **가망은 약합니다.** 지표 하나로 사람 글 0건을 지키며 AI 글을 잡는 방식은 이 규모에서 표시를 섞었을 때와 구별되지 않았습니다. 길이를 맞춘 뒤 뚜렷하게 남은 차이는 MATTR 하나이고, 방향도 표본에서 정한 것입니다. 4.3 에 따라 본 실행으로 넘어가지 않고 사용자와 다시 정합니다.
3. **본 실행 전에 정할 것:** AI 글 분량을 맞추는 방법, 지표 하나 대신 여러 지표를 합친 점수(5.3 의 2단계)를 주 판정으로 삼을지, 번역 글로 보이는 사람 글(Amazon Web Services 한국 블로그 2편)의 처리, 38번 감정 표현을 잴 수단, 11.2 의 결정 승인입니다.

### 11.6 본 실행 비용 견적

파일럿과 같은 조건(분량이 벗어나면 한 번 다시 씀)이면 AI 글 1,500편에 Opus 750편 약 155달러, Sonnet 750편 약 47달러로 합계 약 202달러입니다. 다시 쓰지 않으면 약 104달러입니다. 한 번에 한 편씩 돌리면 약 39시간이 걸립니다. 이 견적에는 플러그인 측정과 판정 비용이 들어 있지 않습니다.

## 갱신 이력

- 2026-09-15: 초안 작성.
- 2026-09-15: 결과를 보기 전에 네 가지를 정해 반영했습니다. 개인 블로그 150편 추가(사람 글 750편, AI 글 1,500편으로 늘어남), 교정 도구는 후보 전부 비교, 「가를 수 없다」가 나오면 그때 의논하되 사후 조정 기록 규칙을 둠, 본 실행 비용은 파일럿 뒤 승인.
- 2026-09-15: 1단계 연구 수집을 반영했습니다. 5.2 를 근거 등급(A~D, 없음)이 붙은 19개 후보 표로 바꾸고, 출처 S9~S23 을 원문 인용과 번역과 함께 더했습니다. 검색 요약과 원문이 달랐던 두 곳(LREAD 수치, 국립국어원 답변)을 10.4 에 적었습니다. 결과를 보기 전의 변경이며 채택 기준은 바꾸지 않았습니다.
- 2026-09-16: 후보를 만드는 근거를 심사를 거친 연구와 국가 연구기관 간행물로 한정했습니다(사용자 결정). 5.2 를 43가지 후보 표로 다시 만들고, 이 규칙에 맞는 연구가 없는 부정 대구·줄표·이중 피동·복수형 `-들` 과 검사 훅 K2·K3·K4·K6·K7 의 표현을 후보에서 뺐습니다. 출처 S24·S25 를 더하고 S1·S12·S13·S14·S16·S21 에 원문에서 확인한 인용과 값을 보탰습니다. 결과를 보기 전의 변경입니다.
- 2026-09-16(파일럿 전 변경): 파일럿을 돌리기 전에 네 가지를 정했습니다. 첫째, 블로그 글의 게시일 대조를 Wayback 에서 Common Crawl 수집본으로 바꿨습니다. Wayback 이 09-15 와 09-16 모두 열리지 않았기 때문입니다. 둘째, 기술 블로그와 개인 블로그의 표본 틀과 시드를 정했습니다. 셋째, AI 글 프롬프트와 실행 조건을 4.2 에 붙였습니다. 넷째, 문서마다 값이 하나인 지표의 검정(Mann–Whitney U), 다중 비교 보정(Benjamini–Yekutieli, q = 0.05), 적중의 정의, 구현에서 나눈 지표와 파일럿에서 재지 않는 지표(38번)를 5.2 와 5.3 에 적었습니다. 첫째와 둘째는 사용자 확인 없이 정했으므로 파일럿 보고에서 확인받습니다. 사람 글 수집은 이 변경을 커밋하기 전에 시작했고, AI 글 생성과 지표 비교는 커밋한 뒤에 돌립니다.
- 2026-09-16(파일럿 결과): 파일럿을 돌리고 11절에 결과를 적었습니다. 지표를 비교하기 전에 수집기 재시도, 제목 규칙, 품사 태그 누락을 고쳤고, 생성 실패 1편 제외와 정리 단계(제목 줄, 미디어위키 제목 줄, 사용자에게 하는 말인 문단)를 정했습니다. 이 결정들은 사전 등록에 없던 것이라 11.2 에 따로 적었습니다. 라벨 섞기와 길이 맞춤은 결과를 본 뒤에 정한 진단이라 사전 등록 판정과 구분해 11.4 에 적었습니다. 4.3 에 따라 본 실행 전에 사용자와 다시 정합니다.
