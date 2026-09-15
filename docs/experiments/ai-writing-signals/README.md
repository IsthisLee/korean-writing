# 한국어 AI 글 신호 분석 장비

[분석 계획](../../analysis/korean-ai-writing-signals.md) 을 돌리는 스크립트입니다. 계획의 기준과 출처는 그 문서에 있고, 이 문서에는 돌리는 순서만 적습니다.

수집한 사람 글 본문, AI 글, 지표, 보고서는 모두 `out/` 에 쌓이고 `.gitignore` 가 커밋을 막습니다. 표본 목록(URL, 날짜, 필자, 글자 수)만 결과를 기록할 때 따로 커밋합니다.

## 준비

```bash
python3 -m venv .venv
.venv/bin/pip install kiwipiepy==0.23.2 trafilatura==2.2.0 spacy==3.8.16 scipy==1.18.1 pyyaml==6.0.3
.venv/bin/python -m spacy download ko_core_news_sm   # 3.8.0
```

AI 글 생성에는 로그인된 `claude` 명령(2.1.272 에서 확인)이 필요합니다.

## 파일럿 순서

```bash
PY=.venv/bin/python
OUT=out/pilot

# 1. 사람 글: 위키 10, 개인 블로그 10, 기술 블로그 10(회사 5곳 × 2편)
$PY collect_wiki.py --n 10 --out $OUT --prefix wiki
gh api repos/sarojaba/awesome-devblog/contents/db.yml?ref=1106089ee274c0846e422e45031cc9b48a289591 --jq .download_url \
  | xargs curl -sL -o $OUT/frames/awesome-devblog-1106089.yml
$PY collect_cc.py personal --db $OUT/frames/awesome-devblog-1106089.yml --n 10 --out $OUT --seed 20260916
curl -sL https://raw.githubusercontent.com/maczniak/awesome-korean-techblog/68fbe200f1fbe44bae1bad1449b71aff80986d09/README.md \
  -o $OUT/frames/techblog-68fbe20.md
python3 frames.py $OUT/frames/techblog-68fbe20.md > $OUT/frames/tech.tsv
$PY collect_cc.py tech --frame $OUT/frames/tech.tsv --companies 5 --per-company 2 --out $OUT --seed 20260916

# 2. AI 글: 사람 글 한 편마다 한 편, 장르마다 opus-5 와 sonnet-5 를 번갈아
$PY generate.py --out $OUT

# 3. 지표와 비교
$PY signals.py $OUT/human/*.txt $OUT/ai/*.txt --out $OUT/features
$PY analyze.py --out $OUT
$PY spotcheck.py --out $OUT
```

수집 스크립트는 이미 저장한 글을 세어 이어서 받습니다. 도중에 멈추면 같은 명령을 다시 돌립니다.

## 파일

| 파일 | 하는 일 |
| --- | --- |
| `common.py` | 기준일, 최소 글자 수(한글 800자), 사람 글과 AI 글에 똑같이 적용하는 정리 함수, 표본 목록 읽기·쓰기 |
| `collect_wiki.py` | 위키백과 무작위 문서의 2022-11-30 이전 마지막 판에서 `<p>` 문단을 뽑음 |
| `frames.py` | 기업 기술 블로그 목록에서 Common Crawl 질의 형식을 붙인 표본 틀을 만듦 |
| `collect_cc.py` | Common Crawl 이 2022-11-30 전에 수집한 블로그 글을 수집본에서 뽑음 |
| `prompts/` | 장르별 AI 글 프롬프트 |
| `generate.py` | `claude -p` 로 AI 글을 씀 |
| `signals.py` | 문서마다 후보 지표를 계산함 |
| `analyze.py` | 사람 글과 AI 글을 비교하고 `report.md`, `results.json` 을 씀 |
| `spotcheck.py` | 형태소 분석과 띄어쓰기 판정을 사람이 대조할 표를 만듦 |
