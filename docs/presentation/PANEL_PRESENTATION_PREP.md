# Panel Presentation — Prep & Q&A Guide
**Stock Market Index Direction Prediction Using Limit Order Book Data** · MTech (DSAI), PES University

> How to use this: Part 1 = what to say per slide. Part 2 = the questions a panel will actually ask, with
> answers (⭐ = high-probability / be ready). Part 3 = numbers to have memorized. Part 4 = defending the weak
> spots. Read Part 2 and Part 4 most carefully — that's where points are won or lost.

---

## Presentation split — 5 presenters
Each presenter owns one thematic block (so handoffs are clean and "what did you do" lines up). The same
assignment + a delivery cue is in each slide's **speaker notes** (presenter view). Swap names to match each
person's actual contribution — Joseph on Data Engineering reflects his role; the rest are suggestions.

| Presenter | Slides | Block | Hand-off cue |
|---|---|---|---|
| **1 · Sumanth G M** | 1–5 | Title, Overview/Abstract, Motivation, Objectives/RQs, Related Work | "…now Joseph on how we built the dataset." |
| **2 · Joseph Raj** | 6–9 | **Data Engineering**, Datasets, EDA, Preprocessing | "…over to Abhishek for the models." |
| **3 · Abhishek Kumar** | 10–12 | Models, FI-2010 Reproduction, NSE Transfer | "…Raghav will cover our Phase-2 studies." |
| **4 · R Raghav Srivatsav** | 13–15 | Tier A (features), Tier B (architectures), Tier C (rigour) | "…Kumar Swamy on efficiency and conclusions." |
| **5 · Kumar Swamy C** | 16–18 | Efficiency, Conclusion & Future Work, Q&A | Opens Q&A for the whole team. |

Roughly even (5/4/3/3/3 slides). In Q&A, route each question to the owner of that block (see the ⭐ topics in
Part 2). Rehearse the four handoffs so transitions are smooth.

## The one-paragraph story (your elevator pitch)
"We tackle short-horizon mid-price direction prediction from limit-order-book data. Because no clean Indian
index-futures LOB dataset existed, we **engineered one end-to-end** — reverse-engineering the Dhan binary feed
and building a cloud collection pipeline for NIFTY/BANKNIFTY futures. We reproduced the standard deep LOB
baselines (DeepLOB, MLPLOB, TLOB) on FI-2010, introduced **MambaLOB**, a linear-time selective state-space
model, and a hybrid **ConvMambaLOB**, and evaluated everything with multi-seed significance tests,
calibration, and HPO. Our honest headline: the SSM models reach **~90% of the transformer's accuracy at
12–25× fewer parameters** — an *efficiency* result, not an accuracy win — and the **largest statistically
significant gain comes from microstructure feature engineering**, not architecture."

Memorize that. Every answer should ladder back to it.

---

## PART 1 — Slide-by-slide talking points

1. **Title** — names, "MTech DSAI capstone, PES." One line: "index-direction prediction from LOB data, with an engineered Indian-market dataset."
2. **Background & Overview (abstract)** — what a LOB is; the deep-LOB progression (DeepLOB → TLOB → Mamba); it's all developed-markets; one-breath project abstract; roadmap. Keep high-level — the detailed survey is the Related Work slide.
3. **Motivation** — LOB has microstructure signal; prior work is all developed-markets/FI-2010; Indian index futures unstudied; *no dataset existed* → we built one.
3. **Objectives/RQs** — engineer dataset; reproduce baselines; propose MambaLOB; quantify transfer; ask "is a linear-time SSM competitive at lower compute?" and "do microstructure features help?"
4. **Related work** — FI-2010 (benchmark), DeepLOB (CNN+LSTM), TLOB (SOTA transformer), Mamba/S4 (SSMs), LOBCAST (models overfit FI-2010), Cont/Stoikov (microstructure priors).
5. **Data engineering (your strongest slide)** — reverse-engineered Dhan binary feed (1992 B/664 B frames), fixed decode bugs, EC2→Parquet→S3 with cron + token refresh, front-month stitching across the expiry roll. ~1.1 M events/instrument.
6. **Datasets** — FI-2010 spec; NSE spec; first-10-levels = 40 features identical to FI-2010 → models transfer unchanged. Be upfront: stored cadence ~0.4 s snapshots, not tick-level.
7. **EDA** — Stationary class shrinks with horizon (19%→4%); spread ~3.3 bps; regular ~2.5 Hz cadence.
8. **Preprocessing** — reorder→clean→per-day segment→train-only z-score→windows→labels (α=1e-5). Microstructure features.
9. **Models** — baselines + MambaLOB (selective SSM, O(L)) + ConvMambaLOB (conv front-end + Mamba).
10. **FI-2010 reproduction** — DeepLOB ≈ paper, TLOB in SOTA range → pipeline validated.
11. **NSE transfer** — all beat baselines (signal exists); below FI-2010 (expected); TLOB leads; **MambaLOB beats DeepLOB on NIFTY at 1/27 the params**.
12. **Tier A — features** — microstructure features give a **significant** gain (+0.084 wF1, p=0.001).
13. **Tier B — architectures** — ConvMambaLOB best of ours; ~90% of TLOB at 12.5× fewer params.
14. **Tier C — rigour** — multi-seed significance, calibration, HPO, class-imbalance. Honest verdicts.
15. **Efficiency** — O(L) vs O(L²); at L=800 ~31× faster, ~750× fewer params.
16. **Conclusion** — dataset + efficient SSM + significant feature finding; honest framing.
17. **Q&A.**

---

## PART 2 — Anticipated panel questions (with answers)

### A. Novelty & contribution  ⭐⭐⭐ (the make-or-break question)
**Q: "This looks like data engineering + applying existing models + a transfer study. What is genuinely novel?"**
> Four concrete contributions: **(1)** the *first ML-ready Indian index-futures LOB dataset* — a reusable
> research artifact built from a reverse-engineered binary protocol; **(2) MambaLOB** — to our knowledge the
> first use of a selective state-space model as a *classification* backbone for LOB direction; **(3)
> ConvMambaLOB**, a hybrid that fuses convolutional spatial extraction with the SSM temporal core; and **(4)**
> a rigorous, *honest* characterization — multi-seed significance, calibration, HPO — yielding the finding
> that *microstructure feature engineering*, not architecture, drives the significant gain on this market.
> Reproduction and transfer are the *foundation* that makes those claims trustworthy, not the contribution
> itself.

**Q: "Your proposed model doesn't beat the SOTA (TLOB). Why is it a contribution?"**
> We never claim to beat TLOB on accuracy — and we say so explicitly. The contribution is the **efficiency
> frontier**: MambaLOB recovers ~90% of TLOB's accuracy with **12–25× fewer parameters** and **linear-time
> O(L)** scaling vs the transformer's O(L²). For latency-/memory-constrained or long-context settings that
> trade-off matters. Claiming a false SOTA win would be the *wrong* science; we'd rather report an honest,
> reproducible trade-off.

### B. Data engineering  ⭐⭐
**Q: "How did you reverse-engineer the binary feed? How do you know it's correct?"**
> Captured raw frames and correlated fields against the live order book. Two frame formats (1992 B full,
> 664 B compact); each level record packs order-count, an IEEE-754 price, and quantity. We validated by
> reconstructing the book and checking against the broker UI, and fixed concrete bugs — bid price at byte
> offset +4, denormalised near-zero floats on empty levels, and int64 storage (uint32 overflowed). 100%
> level-1–10 completeness confirms the parse.

**Q: "Why Dhan over Kite / other sources?"**
> Dhan gives **20 depth levels** (vs Kite's 5), a direct 40-feature match to FI-2010, a per-level
> **order-count** channel Kite lacks, faster updates (~2.5 Hz vs ~1 Hz), 100% completeness, and lower cost.
> We documented this comparison before committing (Table 1 in the report).

### C. Dataset, labelling & the cadence caveat  ⭐⭐⭐ (they will probe this)
**Q: "Your data is ~0.4 s snapshots, not tick-by-tick. Isn't that a problem for LOB modelling?"**
> Honest answer: yes, it's a limitation and we state it plainly. The stored feed is a **regular ~2.5 Hz
> snapshot stream (CV ≈ 0.34)** — *finer* than the one-second snapshots common in prior work, but not true
> event/tick data. The signal is still learnable (all models beat baselines). True tick-level capture is
> explicit future work. *(Note: we corrected this in the report after the data showed it wasn't the
> heavy-tailed "event-driven" stream an early 15-min probe suggested — we report what the data actually is.)*

**Q: "Why α = 1e-5 for labels? Isn't the threshold arbitrary?"**
> It's *calibrated to the price scale*: FI-2010's α=0.002 is far too large for index futures priced at
> ₹24k–₹55k (it would make almost everything Stationary). We chose α to give a usable class balance, and we
> studied the threshold itself: **Scheme A** (fixed α) vs **Scheme B** (spread-relative). Scheme B revealed
> that most moves don't clear the bid–ask spread — an *economic* finding about signal availability, not just
> a hyperparameter.

**Q: "How do you prevent look-ahead / data leakage?"**
> Chronological split (train 12 May–4 Jun, test 5–12 Jun); z-score statistics from **training only**;
> **per-day segmentation** so a window/label never crosses an overnight gap or the contract-expiry roll;
> labels use a symmetric look-back/look-ahead window and the last k rows of each segment are dropped.

### D. Models  ⭐⭐
**Q: "Why Mamba? Why not LSTM or just a transformer?"**
> Mamba is a *selective* state-space model: an input-dependent linear recurrence giving **O(L) time/memory**
> and a **parameter count independent of sequence length** — unlike the LSTM's sequential bottleneck or the
> transformer's O(L²) attention. SSMs were unexplored as a discriminative LOB-direction backbone, so it's a
> genuine novelty window, and the efficiency is the point.

**Q: "Explain the selective state-space mechanism simply."**
> A state h_t is updated as h_t = Ā_t h_{t-1} + B̄_t x_t, y_t = C_t h_t. The "selective" part: Ā, B̄, C are
> *functions of the input*, so the model learns what to remember vs forget per step. A hardware-aware scan
> makes it linear-time. ConvMambaLOB adds DeepLOB's conv front-end for local LOB structure before this core.

### E. Results & evaluation  ⭐⭐
**Q: "Weighted vs macro F1 — which is the real number?"**
> We report **both, always**. The FI-2010 *headline* (~83%) is a weighted F1; independent reproductions
> (LOBCAST) report macro F1 (~72%), which is fairer under class imbalance. Reporting both is precisely why
> our reproduction is credible — weighted matches the paper, macro matches the independent benchmark.

**Q: "Why does accuracy drop so much on NSE vs FI-2010?"**
> Expected and documented (LOBCAST showed all models overfit FI-2010 and drop on new data). NSE is a
> different market, a snapshot feed, and one month of data. The point isn't absolute accuracy — it's that
> *learnable signal exists* (all models beat naive baselines) and the *relative* model ordering and
> efficiency story transfer.

### F. Statistical rigour  ⭐⭐⭐ (examiners love this)
**Q: "How did you test significance? Why is ConvMambaLOB's gain 'not significant' when the per-sample test says p≈0?"**
> Two tests. A **paired across-seed** test (t-test/Wilcoxon over 12 seed×instrument×horizon cells) — the
> meaningful test for *generalizable* improvement. And a **per-sample bootstrap + McNemar** on one cell.
> They disagree for ConvMambaLOB: per-sample says significant only because n≈341k makes any tiny difference
> significant — **large-n over-detection**. The across-seed test (p=0.25) shows the gain is within seed
> noise. We trust the across-seed test and report the gain as *not robust*. (Features, by contrast, are
> significant by *both*, p=0.001.)

**Q: "Calibration — why, and what does T=1.00 mean?"**
> For a downstream cost-aware backtest you need *trustworthy probabilities*, not just labels. Temperature
> scaling fits a single T on validation NLL; **T=1.00 means the model is already well-calibrated** (ECE
> 0.041), so no adjustment is needed — a positive result.

**Q: "Did you tune all models equally for a fair comparison (HPO)?"**
> We ran Optuna on the two proposed models; we **excluded TLOB from HPO for compute reasons** (honest — it's
> a within-family search). The notable result: the *tuned base MambaLOB* (1 layer, d_model=32) matched the
> tuned hybrid, and tuned LRs sat near our defaults — so the comparisons weren't artifacts of bad settings,
> and the *minimal* SSM is the efficiency sweet spot.

### G. Efficiency  ⭐
**Q: "Where do the 31× / 750× numbers come from?"**
> Measured memory/latency at sequence lengths L=100/400/800. TLOB's attention is O(L²) and its parameters
> grow with L; MambaLOB's parameters are constant and cost grows linearly. At L=800: ~31× faster inference,
> ~3.4× less memory, ~750× fewer parameters. (FLOPs for the fused Mamba kernel are under-reported by the
> profiler, so we rely on measured latency/memory — we state that caveat.)

### H. Practical / "can it make money?"  ⭐⭐
**Q: "Is this profitable? Could you trade on it?"**
> We're explicit: **F1 ≠ profit**, and this is *signal-quality* research, not a trading system. The
> Scheme-B analysis showed most predicted moves are smaller than the spread, so naive trading wouldn't clear
> costs. A cost-aware backtest with the calibrated probabilities is future work. We deliberately avoid
> over-claiming profitability.

### I. Limitations (say these *before* they ask — it builds credibility)  ⭐⭐
- One month of data (12 May–12 Jun 2026); single market regime.
- Snapshot cadence (~0.4 s), not true tick data.
- Architecture gains (Tier B) are directionally positive but within seed noise.
- HPO excluded TLOB (compute); within-Mamba-family.
- No live/cost-aware backtest yet.

### J. Reproducibility / engineering  ⭐
**Q: "Can someone reproduce this?"**
> Yes — one data contract for both datasets; a model registry; per-run results + checkpoints versioned on S3;
> dual-GPU sharded runners with S3 resume (timeout-safe); seeded runs; notebooks numbered in execution order;
> requirements pinned. FI-2010 is public (Kaggle); the NSE dataset is provided (sample + full on S3).

### K. Team / individual contribution  ⭐⭐ (prepare per person!)
**Q: "What did *you specifically* contribute?"**
> *(Each member must answer for themselves — agree on this beforehand.)* Joseph: data engineering (Dhan
> parser, collection pipeline) + modelling/experiments. Others: assign clearly — preprocessing, baselines,
> evaluation, documentation, presentation. **Don't let one person answer for all.**

### L. Future work  ⭐
> Spread-relative labelling at scale; cost-aware backtest with calibrated probabilities; walk-forward across
> more months and instruments; true tick-level capture; multi-seed CIs on every config.

---

## PART 3 — Numbers cheat-sheet (memorize)
| Item | Value |
|---|---|
| NSE dataset | NIFTY+BANKNIFTY, 21 days (12 May–12 Jun 2026), ~1.1 M events/instrument, 20 levels |
| FI-2010 DeepLOB | weighted-F1 ≈ 82.5% (paper ~83.4%), macro ≈ 71.9% (≈ LOBCAST) |
| FI-2010 TLOB | up to ~92.5% (SOTA range) |
| NSE wF1 — TLOB | 0.60–0.71 (NIFTY), 0.64–0.72 (BANKNIFTY); lift 0.25–0.30 over baseline |
| NSE — MambaLOB | beats DeepLOB on NIFTY at **68k vs 191k params** (~1/27 of TLOB) |
| Tier A (features) | +0.084 wF1, **p = 0.001** (significant, multi-seed); up to +0.068 at k=100 |
| Tier B | ConvMambaLOB ~90% of TLOB wF1 at **12.5× fewer params**; gain over base **not** significant (p=0.25) |
| Tier C calibration | ECE 0.041, **T = 1.00** (already calibrated) |
| Efficiency @ L=800 | ~31× faster, ~3.4× less memory, ~750× fewer parameters |
| Params | MambaLOB ~70k · ConvMambaLOB ~144k · TLOB ~1.8M |

---

## PART 4 — Defending the weak spots (how to turn a critique into a strength)
1. **"Doesn't beat SOTA"** → Reframe as honesty + efficiency. *"We could have cherry-picked a config to claim
   a win; instead we report the real trade-off. The efficiency result is robust and the dataset is the
   reusable contribution."*
2. **"Architecture gain not significant"** → This is *good science*. *"We ran the multi-seed test precisely to
   avoid over-claiming, and we report the negative honestly. The significant result — features — is the one we
   stand behind."*
3. **"Snapshot, not tick data"** → Acknowledge + scope. *"It's finer than prior 1-second work; we're
   transparent it isn't tick-level; that's the clearest next step."*
4. **"Only one month / one market"** → Acknowledge + frame as pilot. *"This is the first such dataset; the
   pipeline is built to extend across months and instruments — that's the value of the engineering."*
5. **"Lots of engineering, less ML novelty"** → *"The engineering was necessary to even ask the ML question
   on this market — and we did add a novel architecture and a rigorous, significant feature finding on top."*

**Golden rule:** never bluff. If you don't know, say *"good question — we didn't test that; here's how we'd
approach it."* Panels reward honest, structured thinking over confident hand-waving.

---

## PART 5 — Logistics checklist
- [ ] Each member knows their part + can answer "what did you do."
- [ ] Numbers in Part 3 memorized; know which figure backs each claim.
- [ ] Slides in execution order; have the report + paper open as backup.
- [ ] Lead with the one-paragraph story; close with the honest contribution + future work.
- [ ] Anticipate A (novelty), C (cadence/labels), F (significance), H (profit) — rehearse these four.
