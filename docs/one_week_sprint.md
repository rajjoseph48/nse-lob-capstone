# One-Week Sprint Plan — Reconciling the Execution Plan with Reality

*Created 2026-06-10. Hard deadline: ~2026-06-17 (1 week). Solo implementation; team handles docs.*

This is the **executable** version of `NSE_LOB_execution_plan.md`, compressed from 24 weeks to 7 days
and reconciled with work already completed. The full plan remains the methodology reference for the thesis;
this file is what actually gets done.

---

## Decisions locked (2026-06-10)
- **Timeline:** 1 week. Ruthless prioritization.
- **Refactor:** Incremental on existing `modeling/`. **No** Lightning/Hydra/W&B migration this week.
- **TLOB:** Thin wrapper around official repo (`LeonardoBerti00/TLOB`), not a reimplementation.
- **NSE data:** Dhan 20-level on S3 (`lob-capstone-data`, **ap-south-2**). Below the 5M-state target → NSE results
  are caveated as *architecture comparison*, not vs published numbers (already the plan's §1.3 framing).
- **Compute:** All training on **Colab GPU**. Mac (`pes_env` conda, py3.13/torch2.11, MPS-only) = preprocessing/ETL + smoke tests only.

### NSE data inventory (confirmed 2026-06-10 via `pes_env` + boto3)
20 valid Dhan trading days, ~660 MB, across two contracts (clean May→June expiry roll):
- **May-FUT** (`NIFTY-MAY-FUT`, `BANKNIFTY-MAY-FUT`): 12 days, May 11–26, ~684k events/instrument.
- **Jun-FUT** (`NIFTY-JUN-FUT`, `BANKNIFTY-JUN-FUT`): 8 days, Jun 1–10, ~456k events/instrument.
- ~57k events/instrument/day. **Combined ~1.1M events/instrument** — exceeds FI-2010 scale (~400k).
- Skip 3 empty 0-byte files: `20260527/28/29` (collection broke across the roll).
- Kite mirror (5-level, ~3.5 MB/day) exists but has gaps — secondary only.

## The three claims and the minimum evidence each needs
1. **Reproduction** — FI-2010 table: DeepLOB, MLPLOB, TLOB, MambaLOB macro-F1 across horizons vs published, with acceptance tests passed.
2. **Transfer** — NSE Dhan table: same 4 models, event-time Scheme A (+ Scheme B if time). Expected: near-baseline F1 = the finding.
3. **Novelty** — Mamba competitive at equal/lower compute: params / FLOPs / inference latency / memory-vs-sequence-length curve.

---

## What's already done (reuse, don't rebuild)
- Lit survey (19 papers); Dhan EC2→S3 collector live; data quality report.
- `modeling/`: `fi2010_dataset.py`, `nse_dataset.py`, `train.py`, `run_nse_matrix.py` — all working.
- `models.py`: DeepLOB, MLPLOB, MambaLOB (with pure-PyTorch fallback).
- Partial NSE matrix (10/12 runs) in `results/nse_results.csv` — **but run on Mac CPU; Mamba took 21h. Discard and rerun on GPU.**

## What's missing (the week's actual work)
- **FI-2010 reproduction results: do not exist anywhere.** No saved results/checkpoints. THE top priority.
- **TLOB: not implemented.**
- Statistical rigor (seeds, CIs); Scheme B labels; efficiency profiling; nothing committed to git.

---

## Day-by-day

### Day 1 (Tue Jun 10) — Foundation + safety net
- [ ] `git add` + first commit (repo currently has **zero commits**). Add `.gitignore` for data/checkpoints/__pycache__.
- [x] Confirm NSE data volume on S3 (boto3 in `pes_env`) — 20 days, two contracts (see inventory above).
- [x] **Front-month stitching done in `nse_dataset.py`**: match days by root (NIFTY/BANKNIFTY), stitch May+Jun
      contracts, segment labels/windows PER TRADING DAY (roll = segment boundary). New default split:
      train May 12–Jun 4 (15d) / val last 10% / test Jun 5,8,9,10. Validated on a roll-spanning subset:
      both contracts stitched, balanced labels (Down 38% / Stat 24% / Up 38%), `(100,40)` windows. ✅
- [ ] Colab: build `mamba-ssm` + `causal-conv1d` (verify import). Pull `fi2010_dataset.py`/`models.py`/`train.py`.
- [ ] Colab: run FI-2010 smoke (DeepLOB KESKO H=10), then launch **E1 reproduction**: DeepLOB + MLPLOB × horizons {10,20,50,100}. **Save results CSV + checkpoints to S3/Drive** (the bit that was lost last time).
- **Acceptance gate:** DeepLOB FI-2010 H=10 macro-F1 ∈ 80–84% (paper 83.4%). If miss → debug labels/normalization before proceeding.

### Day 2 (Wed Jun 11) — TLOB
- [ ] Clone `LeonardoBerti00/TLOB`; run their FI-2010 pipeline to confirm ≈92.8% F1 (sanity that the repo + data line up).
- [ ] Build `build_model("tlob")` thin wrapper conforming to our data contract: input `(B,100,40)` → logits `[B,3]`.
- [ ] Validate TLOB acceptance (±2 pts of reported). Complete the E1 FI-2010 table (4 models).
- **Fallback if TLOB integration stalls >0.5 day:** keep MLPLOB as the transformer-adjacent baseline, cite TLOB published numbers, mark TLOB-reproduction as deferred. Don't let it sink the week.

### Day 3 (Thu Jun 12) — Mamba on FI-2010 + efficiency
- [ ] MambaLOB on FI-2010 (E2) on GPU (now minutes, not hours). Variants M1 (pure Mamba) + M2 (Mamba temporal + feature attention).
- [ ] mamba-ssm vs `mambapy` parity test (fixed input, assert outputs match within tol) — required before trusting Mac smoke runs.
- [ ] Efficiency profiling for all 4 models: params (torchinfo), FLOPs (fvcore), inference latency (batch=1), peak memory.

### Day 4 (Fri Jun 13) — NSE matrix on GPU
- [ ] Rerun **full** NSE matrix on Colab GPU: 4 models × {NIFTY, BANKNIFTY} × horizons, Scheme A (alpha=1e-5), seq_len=100, OOS test days. Includes the missing TLOB + Mamba-BANKNIFTY runs. Save to fresh `results/nse_results.csv`.

### Day 5 (Sat Jun 14) — Scheme B + seeds/CIs
- [ ] Add Scheme B (spread-relative threshold) labeling fn to `nse_dataset.py`; rerun headline NSE models (E4).
- [ ] 3-seed runs on headline results (FI-2010 4-model + NSE NIFTY) → report mean ± std; bootstrap 95% CIs on test F1.

### Day 6 (Sun Jun 15) — Headline novelty + (stretch) backtest
- [ ] **E6 long-context:** MambaLOB T=400 vs TLOB at matched FLOPs — memory & latency vs sequence-length curve. This is the strongest single novelty figure; prioritize it.
- [ ] *Stretch:* minimal cost-aware backtest (E8) on best NSE model — 1-tick slippage + charges, net hit-rate/Sharpe vs confidence τ. Frame as signal-quality, not a strategy.

### Day 7 (Mon Jun 16) — Tables, figures, handoff
- [ ] Reproduction comparison table (ours vs published, deltas, seed variance).
- [ ] NSE transfer table; efficiency curves; E6 scaling figure.
- [ ] One-paragraph finding per model. Export CSVs + figures for the docs team. Commit + push everything.

---

## Explicitly deferred (out of scope this week — state as future work in thesis)
- Lightning/Hydra/W&B migration (§4.1) · Walk-forward E7 · Wall-clock 1s–60s grid E5 · OFI feature channel ·
  Mamba M3 at T=500 (covered partially by E6) · book-reconstruction (N/A — snapshot data, §9.1).

## Top risks this week
1. **TLOB wrapper eats >1 day** → fallback above.
2. **mamba-ssm won't build on Colab** → `mambapy` on GPU (still far faster than Mac); parity test covers correctness.
3. **NSE data thinner than hoped** → results stay valid as architecture comparison; lean on FI-2010 for the headline.
4. **GPU/session limits** → checkpoint every epoch to Drive/S3; results CSV appended per-run (already the pattern in `run_nse_matrix.py`).
