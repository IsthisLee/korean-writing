#!/usr/bin/env python3
"""AI 판정 여러 벌과 사람 블라인드 평가를 모아 결과를 낸다.

사용: python3 analyze.py <run.sh 출력 폴더> [사람 평가 폴더]
      run 폴더 안의 judge-<기준서>-<판정 모델>/ 을 모두 읽는다.
      사람 평가 폴더는 평가 페이지의 db 를 파일로 받은 것이다(ratings/<문서>.json, 문서마다 rater·pair·choice).
      글 A·B 가 어느 쪽인지는 이 파일 옆 mapping.json 으로 되돌린다.

판정 한 쌍은 순서를 바꿔 두 번 물어 두 번 같은 답일 때만 승패로 센다. 다르면 「갈림」 이다.
부호 검정은 승패만 놓고 양측으로 계산한다. 비김과 갈림은 뺀다.
"""
import collections
import json
import math
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent


def verdicts(jdir):
    out = {}
    for f in sorted(jdir.glob("*_o1.json")):
        i = f.name[:-len("_o1.json")]
        got = {}
        for o in ("1", "2"):
            p = jdir / f"{i}_o{o}.json"
            m = re.search(r"\{.*\}", p.read_text(encoding="utf-8") if p.exists() else "", re.S)
            try:
                w = json.loads(m.group(0)).get("winner") if m else None
            except Exception:
                w = None
            if w not in ("1", "2", "tie"):
                continue
            # 순서1: 글 1 = 스킬, 순서2: 글 1 = im-not-ai
            got[o] = "tie" if w == "tie" else (("skill" if w == "1" else "imnotai") if o == "1" else ("imnotai" if w == "1" else "skill"))
        out[i] = "fail" if len(got) < 2 else (got["1"] if got["1"] == got["2"] else "split")
    return out


def sign_p(w, l):
    n = w + l
    if n == 0:
        return 1.0
    k = min(w, l)
    return min(1.0, 2 * sum(math.comb(n, x) for x in range(k + 1)) / 2 ** n)


def summary(name, v):
    c = collections.Counter(v.values())
    print(f"{name:<42} 스킬 {c['skill']:>2} · im-not-ai {c['imnotai']:>2} · 비김 {c['tie']:>2} · 갈림 {c['split']:>2}"
          f" · 실패 {c['fail']:>2} · 부호 검정 p={sign_p(c['skill'], c['imnotai']):.3f}")


def agree(a, b):
    both = [i for i in a if i in b and a[i] in ("skill", "imnotai", "tie") and b[i] in ("skill", "imnotai", "tie")]
    same = sum(a[i] == b[i] for i in both)
    return same, len(both)


def humans(folder):
    # 축은 둘이다. choice 는 자연스러움(AI 판정과 같은 기준)이고 structure 는 글의 짜임새다.
    # 한 쌍에서 두 축의 답이 갈릴 수 있다. 갈린 쌍의 수 자체가 결과다.
    mapping = json.loads((HERE / "mapping.json").read_text(encoding="utf-8"))["pairs"]
    axes = {"choice": collections.defaultdict(dict), "structure": collections.defaultdict(dict)}
    for f in pathlib.Path(folder).rglob("*.json"):
        d = json.loads(f.read_text(encoding="utf-8"))
        d = d.get("data", d)
        pair, rater = d.get("pair"), d.get("rater")
        if pair not in mapping or not rater:
            continue
        for axis, by_rater in axes.items():
            v = d.get(axis)
            if v in ("A", "B", "tie"):
                by_rater[rater][pair] = "tie" if v == "tie" else mapping[pair][v]
    return axes["choice"], axes["structure"]


def main():
    run = pathlib.Path(sys.argv[1])
    judges = {d.name[len("judge-"):]: verdicts(d) for d in sorted(run.glob("judge-*")) if d.is_dir()}
    print("== AI 판정")
    for name, v in judges.items():
        summary(name, v)
    names = list(judges)
    if len(names) > 1:
        print("\n== AI 판정끼리 같은 답을 낸 쌍 (둘 다 확정한 쌍 가운데)")
        for x in range(len(names)):
            for y in range(x + 1, len(names)):
                s, n = agree(judges[names[x]], judges[names[y]])
                print(f"{names[x]} ↔ {names[y]}: {s}/{n}")
    if len(sys.argv) > 2:
        raters, structs = humans(sys.argv[2])

        def majority_of(per_rater):
            votes = collections.defaultdict(collections.Counter)
            for v in per_rater.values():
                for i, c in v.items():
                    votes[i][c] += 1
            out = {}
            for i, cnt in votes.items():
                top = cnt.most_common()
                out[i] = top[0][0] if len(top) == 1 or top[0][1] > top[1][1] else "split"
            return out

        print(f"\n== 사람 평가: 자연스러움 (평가자 {len(raters)}명)")
        for r, v in raters.items():
            summary(f"평가자 {r} ({len(v)}쌍)", v)
        majority = majority_of(raters)
        summary("다수 의견", majority)

        if structs:
            print(f"\n== 사람 평가: 글의 짜임새 (평가자 {len(structs)}명)")
            for r, v in structs.items():
                summary(f"평가자 {r} ({len(v)}쌍)", v)
            maj_struct = majority_of(structs)
            summary("다수 의견", maj_struct)

            print("\n== 두 축이 갈린 쌍 (평가자별로 같은 쌍의 두 답을 견줌)")
            tot = split = 0
            for r, v in raters.items():
                s = structs.get(r, {})
                both = [i for i in v if i in s]
                diff = [i for i in both if v[i] != s[i]]
                tot += len(both)
                split += len(diff)
                if both:
                    print(f"평가자 {r}: {len(diff)}/{len(both)} 갈림" + (f" ({', '.join(sorted(diff))})" if diff else ""))
            print(f"합계: {split}/{tot} 쌍에서 자연스러움과 짜임새의 답이 달랐다")

        print("\n== 사람 다수 의견(자연스러움)과 AI 판정의 일치 (둘 다 확정한 쌍 가운데)")
        for name, v in judges.items():
            s, n = agree(majority, v)
            print(f"{name}: {s}/{n}")


if __name__ == "__main__":
    main()
