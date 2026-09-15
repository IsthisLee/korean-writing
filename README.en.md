<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/assets/hero.en.svg">
  <source media="(prefers-color-scheme: light)" srcset="docs/assets/hero-light.en.svg">
  <img src="docs/assets/hero.en.svg" alt="korean-writing: sentences Claude Code actually wrote next to the same sentences fixed by the rules, and the two moments it covers" width="100%">
</picture>

<p align="center">
  <a href="README.md">한국어</a> · <strong>English</strong>
</p>

<p align="center">
  <strong>A Claude Code plugin that makes Claude write Korean without translationese or AI tells.</strong><br>
  When a <code>.md</code> is saved, AI tells are flagged and handed back to Claude in the same turn.<br>
  Text that already exists keeps its facts and has only its style fixed.<br>
  Two commands to install, nothing to configure. Nothing you write leaves your machine.
</p>

<p align="center">
  <a href="https://github.com/IsthisLee/korean-writing/actions/workflows/validate.yml"><img alt="Validate" src="https://github.com/IsthisLee/korean-writing/actions/workflows/validate.yml/badge.svg?branch=main"></a>
  <a href="https://github.com/IsthisLee/korean-writing/actions/workflows/codeql.yml"><img alt="CodeQL" src="https://github.com/IsthisLee/korean-writing/actions/workflows/codeql.yml/badge.svg?branch=main"></a>
  <a href="https://scorecard.dev/viewer/?uri=github.com/IsthisLee/korean-writing"><img alt="OpenSSF Scorecard" src="https://api.securityscorecards.dev/projects/github.com/IsthisLee/korean-writing/badge"></a>
  <img alt="MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
  <img alt="Claude Code Plugin" src="https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2">
  <img alt="version" src="https://img.shields.io/badge/version-2.1.0-lightgrey">
  <img alt="network" src="https://img.shields.io/badge/network-none-success">
  <img alt="platform" src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey">
  <a href="https://github.com/IsthisLee/korean-writing/commits/main"><img alt="last commit" src="https://img.shields.io/github/last-commit/IsthisLee/korean-writing"></a>
</p>

<p align="center">
  <a href="#overview">Overview</a> ·
  <a href="#examples">Examples</a> ·
  <a href="#three-minutes-to-try-it">3-minute start</a> ·
  <a href="#install">Install</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#what-it-builds-on">Basis</a> ·
  <a href="#components">Components</a> ·
  <a href="#the-verdict-rules">Verdict rules</a> ·
  <a href="#verification">Verification</a> ·
  <a href="#how-it-differs-from-other-tools">Compared with other tools</a> ·
  <a href="#faq">FAQ</a>
</p>

## Overview

Claude Code's Korean is grammatically fine. It still reads wrong: word order carried over from English, metaphors that arrived through English, and stock phrases that land in the same spot of every document.

A prompt cannot patch this reliably, and polishing a finished draft leaves framing such as a first/next/finally sequence in place. So two moments get an owner: when Claude saves text to a file, and when existing text is revised. The style of text as it is first written is left to the output style you choose. Installing turns on both at once, and there is nothing to remember to call.

| Moment                                                        | What covers it                                                                                           | When it runs                             | Where the rules live                     |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| **On save**<br>anything that lands as `.md`                   | A PostToolUse hook checks what was just written and hands the findings back to Claude in the same turn   | Right after `Edit`, `Write`, `MultiEdit` | `plugin/hooks-handlers/posttooluse.sh`   |
| **When revised**<br>someone else's draft, an old document | The polishing pipeline fixes the style and leaves the facts alone                                        | When you ask for a touch-up              | `plugin/skills/humanize-korean/SKILL.md` |

One more skill sits alongside: character counts come from a script rather than the model's guess.

> Think of a linter, attached to Korean prose instead of code. The findings on save reach Claude within the same turn, so they get fixed before you read the file.

## Examples

### Sentences, before and after

What the rules are after is easiest to see in the ground truth, before and after. Every "before" was actually written by Claude Code; every "after" is the same sentence fixed by this repository's rules.

| Before (as Claude Code wrote it)                                                                                | After (fixed by the rules)                                                                             | What was wrong                                                                                                                  |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- |
| 규칙이 충돌하면 상위 문서가 **이깁니다**. 둘 다 값이 있을 때는 텍스트가 **이기고** 강의실 참조는 무시됩니다.    | 규칙이 충돌하면 상위 문서를 따릅니다. 둘 다 값이 있을 때는 텍스트가 우선하고 강의실 참조는 무시됩니다. | "The upper document wins": documents made to compete like people                      |
| 원인은 힙 부족이 아니었습니다 **—** 실측해보니 **—** 설정이 아예 먹히지 않았습니다.                             | 원인은 힙 부족이 아니었습니다. 실측해 보니 설정이 아예 먹히지 않았습니다.                              | An em-dash interjection, English punctuation copied into Korean |
| 여기서 갈리는 **축은** 프로젝트 전용 여부가 아니라 성격입니다. 두 문제는 **결이** 다르고 **레이어도** 다릅니다. | 여기서 갈리는 기준은 프로젝트 전용 여부가 아니라 성격입니다. 두 문제는 성격이 다른 별개의 문제입니다.  | "Axis," "grain," "layer": structure described through metaphor                                                                  |
| 시험용 장비가 몇 초 만에 **쓰러졌습니다**. **일으켜 세우면** 또 쓰러지기를 스무 분 넘게 반복했습니다.           | 시험용 장비가 몇 초 만에 멈췄습니다. 다시 켜면 또 멈추기를 스무 분 넘게 반복했습니다.                  | Equipment "falling over" and being "stood back up": an English metaphor translated literally                                    |

### What you see on save

This is what appears in Claude Code after a `.md` edit. The window frame is drawn; from the yellow line down it is the hook's actual output, unchanged.

<p align="center"><img src="docs/assets/hook-output.svg" alt="Hook output flagging K1, K2, K3 and K7" width="860"></p>

Each flagged spot carries its line number and an excerpt, so Claude fixes only those spots. This output goes back to Claude too: Claude Code shows the stderr of a PostToolUse hook that exits 2 to Claude in the same turn ([experiment](./docs/experiments/hook-loop/)).

## Three minutes to try it

1. Install. Two commands, nothing to configure.
   ```bash
   claude plugin marketplace add IsthisLee/korean-writing
   claude plugin install korean-writing
   ```
2. Open a new session and ask for text saved as a `.md` file.
   ```
   이번 배포 QA 보고서를 배포-QA.md로 써줘.
   ```
3. The hook checks what was just written and, if anything is flagged, prints output like the one above, and Claude fixes it on the spot. If nothing is flagged, it stays silent.

## Install

```bash
claude plugin marketplace add IsthisLee/korean-writing
claude plugin install korean-writing
```

When `claude plugin list` shows `korean-writing` as `enabled`, you are done. New versions come with `claude plugin update korean-writing`. A local checkout can be registered as a marketplace too, for an internal copy or a fork.

```bash
claude plugin marketplace add /path/to/korean-writing
claude plugin install korean-writing
```

| Needed      | Used by                                                                                      | Without it                                                          |
| ----------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| Claude Code | Everything. Verified on 2.1.267                                                              |                                                                     |
| `bash`      | The check hook and the scripts                                                               | The hook does not run                                               |
| `python3`   | The check hook and the polishing pipeline's scripts; polishing needs 3.10 or newer | The check passes without checking; the polishing scripts do not run |
| `node` 18+  | The character-count script                                                                   | Only that skill is unavailable                                      |

There are no packages to download. CI runs the same checks on macOS and Linux. Windows needs Git Bash or WSL and has not been tried yet.

### Outside Claude Code

The character-count skill follows the [Agent Skills](https://agentskills.io/specification) format, so it also installs into other agents such as Codex, Cursor and Gemini CLI. The [Skills CLI](https://skills.sh) finds it in the repository.

```bash
npx skills add IsthisLee/korean-writing -s korean-character-count -g
```

The check hook and the polishing pipeline run only in Claude Code: the hook attaches to Claude Code's hook events, and polishing calls Claude Code subagents. Other agents get the character count, nothing more.

## Usage

Talk to Claude Code as usual; polishing and character counting load from the request, and the check hook runs when a `.md` is saved. These lines can be pasted as they are.

```
아래 글 번역투만 고쳐줘. 사실과 숫자는 그대로 두고.           (fix only the translationese below; keep facts and numbers)
이 자기소개서 공백 포함 몇 자야? 1,000자 제한이야.            (how many characters including spaces? the limit is 1,000)
이 프로젝트 README 써줘. 오픈소스용으로.                       (write a README for this project, open-source style)
이번 배포 QA 보고서를 배포-QA.md 로 써줘.                       (write this release's QA report to 배포-QA.md)
```

Here is what loads on its own, when, and what to type to call it by name.

| What                             | Runs on its own when                                          | Direct call                                                      |
| -------------------------------- | ------------------------------------------------------------- | ---------------------------------------------------------------- |
| Polishing                        | "AI 티 없애줘", "번역투 고쳐줘" and similar requests           | `/korean-writing:humanize [text or file path]`                   |
| A second polishing pass          | Never on its own; it has to be called by name                 | `/korean-writing:humanize-redo [instruction]`                    |
| The check hook                   | Right after `Edit`, `Write` or `MultiEdit` touches a `.md`    | `/korean-writing:check FILE...`                                   |
| Character counting               | "500자 이내로", "글자 수 세줘" and similar requests            | `/korean-writing:korean-character-count`                         |

The check hook has no name to call: it runs when its condition is met and stays quiet otherwise. The two polishing entry points (`humanize`, `humanize-redo`) run only when typed, and in exchange they cost nothing in always-on context.

The style of ordinary answers and of newly written text is left to whichever output style you choose. This plugin dropped its output style on 2026-09-14 and its writing skill (`/korean-writing`) on 2026-09-15. Why is recorded in [CHANGELOG.md](CHANGELOG.md).

### Getting the best text

1. **Have it saved as a `.md` file.** The check hook hands back each flagged spot with its line number and Claude fixes it in the same turn.
2. **Polish drafts that already exist with `/korean-writing:humanize`.** The polishing pipeline keeps the facts and fixes only the style.

### Turning it off

It can be switched off at several scopes, and individual rules can be turned off on their own.

| Scope                | How                                                                                                                                 |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| One file             | `<!-- korean-writing: ignore -->` at the top. For contracts, or a catalog of bad examples, where flagging every time makes no sense |
| Some rules in one file | `<!-- korean-writing: disable K1 K4 -->` at the top. For a document that uses em dashes on purpose |
| A repository         | Commit a `.korean-writing.json` so the whole team shares one standard. Example below                                               |
| Some rules, persistently | The plugin setting `disabled_rules`, or `KOREAN_WRITING_DISABLE_RULES=K1,K4`                                                  |
| Whole session        | `KOREAN_WRITING_HOOK_DISABLED=1`. Turns off the check hook                                         |
| The whole plugin     | `claude plugin disable korean-writing`                                                                                              |

```json
{
  "disable": ["K1"],
  "ignore": ["legal/*", "CHANGELOG.md"]
}
```

The hook uses the first `.korean-writing.json` it finds walking up from the edited file, and stops at the folder holding `.git`, so settings from outside the repository never mix in. The hook's message never mentions how to turn rules off: if it did, Claude could switch a rule off instead of fixing the wording.

## What it builds on

The Korean judgements are not invented; they rest on three layers.

The base is translation studies. The patterns come from the eight classic kinds of translationese long studied in Korean translation scholarship (inanimate subjects, overuse of the passive, literal pronouns, mechanical `-들` pluralization, literal relative clauses, nominalization, stacked particles, sentence endings) and from international translation theory (Baker 1993 on translation universals, Toury 1995, Toral 2019 on post-editese). On top of that sits an AI-tell taxonomy: im-not-ai's 10 categories and 84 items, from translationese through rhythmic uniformity, over-modification and euphemism, each rated by severity.

The rules are filtered by measurement. im-not-ai measured each pattern's discriminating power on a contrast corpus, rejected patterns that are common in human writing too, and checked model dependence to separate items that only one model pushed up. Items such as the negated antithesis and the comma after a connective ending were re-measured on 532 human-written texts and their thresholds adjusted. This repository filtered the check hook's rules the same way on a corpus of real documents: "죽다" (to die) left K7 because "the server died" is everyday developer speech, and the `~에 대해`/`~를 통해` counts left K8 because they only ever flagged human writing. A rule that discriminates well was still dropped when its fix made Claude cut sentence components: that is why the negated antithesis, the comma after a connective ending and 첫째·둘째 enumeration left the hook on 2026-09-14.

The documents behind all of this are gathered in [docs/foundations.md](docs/foundations.md) (Korean), which points to the research literature, the taxonomy, the rules this repository wrote, and the harnesses that reproduce the measurements.

## Components

Here is what the plugin ships with.

| Part           | Count        | What                                                                                                                                                                                                               |
| -------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Skills         | 4            | one written here, `korean-character-count`, and three vendored from im-not-ai, `humanize-korean`, `humanize`, `humanize-redo` |
| Hooks          | 1            | a check right after `.md` edits |
| Check patterns | 7            | `K1`–`K4` and `K6`–`K8`: em-dashes, abstract structure words, 것 constructions, AI idioms, win/lose and object personification, translationese |
| Agents         | 3            | vendored from im-not-ai: diagnosis, rewrite and final review for the polishing pipeline                                                                                                                            |
| Rulebook       | 84 items     | im-not-ai's taxonomy: 10 categories, each item with a severity and a fix                                                                                                                                           |
| Ground truth   | 15 sentences | 10 violations Claude Code actually generated, 5 clean sentences from the same context                                                                                                                              |
| Scripts        | 5 + 9        | five written here: character count, whole-file check, false-positive measurement, release, image. The nine vendored from im-not-ai serve the polishing pipeline |
| Network        | none         | the hooks are bash and python3 regular expressions; the counter uses `node:fs`                                                                                                                                     |

- **Polishing (vendored from im-not-ai).** The pipeline that touches up existing text was not written here. The runtime subset of [im-not-ai](https://github.com/epoko77-ai/im-not-ai) is vendored as it is from commit `9747f03`. It picks a path from one to three calls by the state of the text and discards the result above a 50% change rate. One line was changed in the vendored files: a trigger phrase in the skill description.
- **The `korean-character-count` skill.** It loads for text under a length limit. 각 is one character but three bytes in UTF-8, and a syllable assembled from jamo looks like one character while being three code points, so a script counts rather than the model. The counting contract is in `plugin/skills/korean-character-count/instruction.md`.
- **The check hook.** It runs right after `Edit`, `Write` or `MultiEdit` touches a `.md` and looks only at what was just written, because checking the whole file would re-flag old wording on every edit. To check existing documents or run in CI and pre-commit, `plugin/scripts/check.sh FILE...` exits 1 if any file is flagged.

## The verdict rules

1. When one of `Edit`, `Write` or `MultiEdit` finishes, Claude Code serializes the tool input as JSON and feeds it to `plugin/hooks-handlers/posttooluse.sh` on stdin.
2. If `KOREAN_WRITING_HOOK_DISABLED` is 1, or `python3` cannot be found, it passes without looking at anything.
3. A path that does not end in `.md` passes.
4. From the tool input it gathers only what was just written. If `<!-- korean-writing: ignore -->` stands on a line of its own in what was written or in the first ten lines of the file, it passes.
5. It strips code blocks, inline code, URLs, table rows and HTML comments. Table rows go entirely because a document that quotes bad examples must not be flagged for the examples.
6. If Hangul makes up more than 30% of what is left, all of it is checked; if not, only the lines that are at least 30% Hangul are kept. If fewer than 20 Hangul characters survive, it passes.
7. The regular expressions `K1`–`K4` and `K6`–`K8` run over what remains.
8. With no hits it ends quietly with exit code 0. With hits it writes each item to stderr, with the count and how to fix it, and exits 2. Either way the file is not touched.

| Code  | What                             | What the regex looks for                                                                                    | Fires at                                                     |
| ----- | -------------------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| `K1`  | Em-dash interjection             | `—` or `–` with a space and a character on both sides                                                       | 4. If the edit adds at least one, the whole file is counted  |
| `K2`  | Abstract structure words         | `축이·축은·축을·축으로`, `갈래`, `결이 다르`, `레이어`                                                      | 3                                                            |
| `K3`  | Translationese 것 constructions | `것들이었`·`것들이다`, `것들을`, `하는 것이 가능`                                                           | 1                                                            |
| `K4`  | AI idioms                        | `시사하는 바가 크`, `주목할 만하`, `혁신적`·`획기적`·`압도적`                                               | 1                                                            |
| `K6`  | Win/lose personification         | `~가 이긴다·이깁니다·이겼다·이기고`                                                                         | 2                                                            |
| `K7`  | Personified objects              | screens, servers, devices and the like that `굳·쓰러지·넘어지·일어서·잠들`; `넘어뜨리·일으켜 세우·쓰러뜨리` | 1                                                            |
| `K8`  | Translationese                  | `가지고 있`, the double passive `되어지`, `에 의해`                                                          | 1 per item, `에 의해` at 2                                   |

`K5` mechanical enumeration, `K9` negated antithesis and `K10` comma after a connective ending were removed on 2026-09-14. With the fluent-korean output style on, 4 of 12 replies were flagged by `K5` or `K9`, and the text of that style guide itself was flagged by `K10`. One sample also lost the words that linked a cause to its result when `K9`'s fix split a sentence in two. The same day `K4` dropped connectives such as `결론적으로` and `종합하면` and the hedge `라고 할 수 있다`, and `K8` dropped the auxiliary `지게 된다`. Removed numbers are not reused, so a `K9` left in a setting turns off nothing ([EVALUATION.md](EVALUATION.md) section O).

The em-dash is counted across the whole file. Fixing a document one paragraph at a time adds one or two per edit and dozens to the file, yet no single edit ever reaches the threshold when only the edit is counted. An edit that adds none is never flagged no matter how many the file holds, so editing old documents does not get noisier.

Thresholds are one step above the rulebook's. It informs rather than blocks, because flagging a sound sentence and breaking someone's flow does more harm than missing one.

## Principles

**Do not block.** The check hook informs and never reverts an edit. On a machine without `python3` the check is skipped. The moment a checker starts blocking work, people switch it off.

**No rule changes without numbers.** Adding or removing a pattern, or moving a threshold, needs a result from real documents. Those changes are on record in [EVALUATION.md](./EVALUATION.md).

**Flagging a sound sentence is worse than missing one.** The pass criteria are ordered that way: zero false positives on clean sentences comes first, detection second.

**No contact with the outside.** What the hook reads and never does is in [SECURITY.md](./SECURITY.md), together with `grep` commands that let you check for yourself.

**What is always loaded stays small.** Ordinarily only four skill descriptions and three agent descriptions enter the context, and the large files open when their job comes up.

**Imported files stay imported.** The polishing pipeline and the counting script belong to other MIT projects. [plugin/NOTICE.md](./plugin/NOTICE.md) records, file by file, which commit each came from and which lines were changed.

## Verification

Where these verdicts come from is mapped in [docs/foundations.md](./docs/foundations.md), and the pass criteria and measurements are in [EVALUATION.md](./EVALUATION.md) (both Korean). The criteria form six groups, hook accuracy, skill triggering, skill effectiveness, structural soundness, failure modes and the user's own criteria, and any group that falls short gets fixed and measured again. The headline numbers:

| Measurement                        | Result                          |
| ---------------------------------- | ------------------------------- |
| False positives on real documents  | 1 / 205 (0.5%)                  |
| False positives on clean sentences | 0 / 5                           |
| Same-turn fix after a hook finding | 3 / 3 (0 / 3 without the plugin) |
| Network calls                      | 0                               |
| Regression tests                   | 84 / 84                         |

False positives on real documents were measured on 205 Korean `.md` files that had accumulated on one machine, unrelated to this plugin. Fed through the hook whole, 85 were flagged; separated by file modification year, one of the 32 files written before 2024 was flagged.

## What it does not do

- **Ordinary replies get no rules.** Up to v1.1.0 reply rules were injected when a session opened and when a subagent started. Style improved, but replies were measured losing details such as default values, so the injection was removed ([EVALUATION.md](./EVALUATION.md) H13). The style of ordinary conversation is not this plugin's job.
- **Newly written text gets no rules either.** Until 2026-09-15 a writing skill could be called with `/korean-writing`. Now the output style you choose handles style, and this plugin handles the check after saving and the polishing.
- The check hook looks only at `.md` files. Korean comments and strings inside code, and replies that go straight out to Slack, have no check afterwards.
- The regular expressions catch seven known markers. New kinds of awkwardness have to be found by a person and added.
- Only what the hook flags gets fixed; anything it misses stays.
- Contracts, terms of service, legal documents and official letters are out of scope; formality is their requirement. Code, logs, commands, quotations, proper nouns and English source text are left alone.
- Spelling and spacing are not checked. Style only.

## Repository layout

The repository has two layers. **Only `plugin/` is copied onto an installer's machine.** Installing a plugin takes the whole folder with no way to exclude anything, so tests, experiments and CI live outside it. The `설치본 경계` CI job keeps that line.

```
korean-writing/
├── plugin/                the shipped plugin; only this folder reaches other machines
│   ├── .claude-plugin/    manifest (name, version source of truth, skill paths)
│   ├── hooks/             registers PostToolUse
│   ├── hooks-handlers/    check after a .md edit (K1–K4, K6–K8)
│   ├── commands/          /korean-writing:check
│   ├── agents/·skills/    vendored im-not-ai polishing + the counting skill
│   ├── scripts/           whole-file check + the im-not-ai polishing scripts
│   └── NOTICE.md·LICENSE  origin of imported files, and MIT
│
├── tests/                 everything below stays in the repository:
│                          regression tests and ground truth
├── tools/                 maintainer scripts (guard, release, measure, images)
├── docs/                  images (assets), experiments, samples, foundations.md
├── EVALUATION.md          pass criteria and measurements
├── CLAUDE.md              rules for Claude working in this repository
└── README.md·README.en.md
```

## How it differs from other tools

There are already several tools that make Korean read naturally. The most widely used ones polish text after it is written, and this plugin's polishing is one of them: im-not-ai, vendored at a pinned commit. What this plugin adds is the moment before that: the turn in which Claude saves the file.

| Tool                                                               | When first written                                                       | On save                                                                              | When revised                                                       | Network                                                                   |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| **korean-writing**                                                 |                                                                          | A hook checks right after the edit and hands findings back to Claude in the same turn | im-not-ai, vendored                                                | None; CI enforces it                                                      |
| [im-not-ai](https://github.com/epoko77-ai/im-not-ai)               |                                                                          |                                                                                      | Polishing pipeline (1 to 3 calls)                                  | None                                                                      |
| [fluent-korean](https://github.com/snflkd/fluent-korean)           | An output style applied to every reply; aims for unambiguous sentences   |                                                                                      |                                                                    | None                                                                      |
| [patina](https://github.com/devswha/patina)                        |                                                                          | A pre-commit hook scores Markdown at commit time                                     | Polishing (skill, CLI, web) for Korean, English, Chinese, Japanese | The web version runs server-side                                          |
| [k-skill](https://github.com/NomaDamas/k-skill) `korean-humanizer` |                                                                          |                                                                                      | Polishing                                                          | Instructions are fetched with `npx`; spell-check uses external checkers   |

Checked against each repository on 2026-09-11. A blank cell means no feature for that moment was found. patina also checks on save, but at a different moment: patina runs when a person commits, this plugin runs in the turn where Claude edited the file.

This plugin does not ship an output style for ordinary answers. With a style such as fluent-korean's turned on, the check hook and the polishing keep working.

## FAQ

<details>
<summary><b>Why does the check hook look only at .md files?</b></summary>

The hook receives the tool input after a file-editing tool finishes, so it cannot see replies that are not files. Checking replies with the regular expressions afterwards was tried too: on ordinary replies it caught 0.21 items per sample, too few to serve as a monitor.

Evidence: N3 in [EVALUATION.md](./EVALUATION.md).

</details>

<details>
<summary><b>Does the hook revert my edit?</b></summary>

It does not. The hook's job ends at writing the items to stderr and exiting 2. The file stays exactly as edited, and whether to fix it is for Claude Code and you to decide.

Evidence: the "What this plugin does" table in [SECURITY.md](./SECURITY.md).

</details>

<details>
<summary><b>Does my text leave my machine?</b></summary>

It does not. The hooks run python3 regular expressions inside bash and the counting script imports nothing but `node:fs`. Anyone can confirm there is no network call and no external program with the three `grep` commands in [SECURITY.md](./SECURITY.md).

</details>

<details>
<summary><b>Does it flag contracts and terms of service?</b></summary>

It does, which is why a single line at the top of the file, `<!-- korean-writing: ignore -->`, takes that file out of the check.

</details>

<details>
<summary><b>How many tokens does it cost?</b></summary>

The always-on cost is four skill descriptions, about 430 tokens (the vendored polishing skill's 230 included), and three agent descriptions, about 300. A skill body loads only when that skill is used, and the hook never calls an LLM.

Evidence: D2 and F7 in [EVALUATION.md](./EVALUATION.md).

</details>

<details>
<summary><b>I installed it but the skills do not show up.</b></summary>

First check that `claude plugin list` reports `korean-writing` as `enabled`. If the repository is symlinked into `~/.claude/skills/` and also installed from the marketplace, remove one of the two. The skill list only changes in a new session.

</details>

<details>
<summary><b>Does it work on Windows?</b></summary>

It has not been tried. The hooks are bash scripts, so Git Bash or WSL has to be there. `.gitattributes` pins the scripts to LF, so a CRLF checkout cannot break them. If you try it, open an issue with the result and it will be recorded here.

</details>

## Contributing

The procedure is in [CONTRIBUTING.en.md](./CONTRIBUTING.en.md). The most valuable contribution is not code but sentences. If you have seen Claude Code write awkward Korean, or the hook flag a perfectly fine sentence, send the unedited original through the [awkward sentence report](https://github.com/IsthisLee/korean-writing/issues/new?template=awkward-sentence.yml) form. Reported sentences go into the ground truth or the clean set and become regression tests.

The first step is a baseline run.

```bash
git clone https://github.com/IsthisLee/korean-writing.git
cd korean-writing
python3 tests/test_posttooluse.py
plugin/scripts/check.sh --all
```

A change to a rule comes with numbers from `tools/measure.sh` on real documents and with regression tests. Korean documents you touch must pass `plugin/scripts/check.sh`, and a README change lands in both the Korean and the English edition. Commit subjects are Conventional Commits in Korean, and the version number is left alone.

## Sources and license

| File                                                                                              | From                                                                                                                            | Changed                                                            |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `plugin/skills/humanize-korean/`, `plugin/skills/humanize/`, `plugin/skills/humanize-redo/`, `plugin/agents/`, `plugin/scripts/*.py` | The runtime subset of [im-not-ai](https://github.com/epoko77-ai/im-not-ai) at commit `9747f03` (2026-09-06)                     | One trigger phrase in the skill description                        |
| `plugin/skills/korean-character-count/`                                                                  | [k-skill](https://github.com/NomaDamas/k-skill)                                                                                 | Script unchanged, run path in the instructions, SKILL.md rewritten |

The rest was written in this repository: the whole check hook, the ground truth and the evaluation criteria. Every imported file is MIT-licensed and the original copyright notices are gathered in [plugin/NOTICE.md](./plugin/NOTICE.md). This repository is [MIT](./LICENSE) too.

---

<p align="center"><sub>Built with <a href="https://claude.com/claude-code">Claude Code</a> · <a href="./LICENSE">MIT</a></sub></p>
