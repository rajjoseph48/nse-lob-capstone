# Notebooks — execution order

Run the numbered notebooks in order. Each is self-contained: it installs dependencies, fetches the code,
loads data (FI-2010 from Kaggle; NSE from sample / S3), trains, and saves results. Credentials are read from
the Kaggle/Colab secret store or environment — never hardcoded (see `get_secret`).

| # | Notebook | Purpose |
|---|----------|---------|
| 01 | `01_fi2010_reproduction.ipynb` | Reproduce DeepLOB & MLPLOB on the FI-2010 benchmark. |
| 02 | `02_tlob_reproduction.ipynb` | Reproduce the TLOB transformer baseline (SOTA reference). |
| 03 | `03_mamba_and_efficiency.ipynb` | Proposed MambaLOB on FI-2010 + the O(L) vs O(L^2) efficiency study. |
| 04 | `04_nse_eda.ipynb` | Exploratory analysis of the engineered NSE dataset. |
| 05 | `05_nse_matrix.ipynb` | NSE Scheme-A transfer matrix (4 models × 2 instruments × 4 horizons). |
| 06 | `06_nse_extras.ipynb` | Scheme-B labelling, multi-seed, and the cost-aware backtest. |
| 07 | `07_nse_feature_ablation_tierA.ipynb` | Tier A — microstructure feature-engineering ablation. |
| 08 | `08_tier_b_architecture.ipynb` | Tier B — improved architectures (bidirectional Mamba, ConvMambaLOB). |
| 09 | `09_tier_c_rigour.ipynb` | Tier C — multi-seed significance + probability calibration. |
| 10 | `10_tier_c_hpo_imbalance.ipynb` | Tier C — Optuna hyperparameter optimisation + class-imbalance study. |

`util_dual_gpu_runner.ipynb` — reusable dual-GPU (sharded) execution harness for the Tier-A/B grids; not a
sequential step.

## `from_kaggle/`
Executed copies **with outputs** (the actual runs that produced the reported results), using the same order
prefixes. `from_kaggle/HTML/` holds static HTML exports for viewing without running. (Not every step has an
executed Kaggle copy — EDA and extras were run locally.)
