"""Generate appendix_tables.tex (full per-run result tables) from the S3 result CSVs."""

import io
import boto3
import pandas as pd

s3 = boto3.client("s3", region_name="ap-south-2")
B = "lob-capstone-data"
OUT = (
    "/Users/joseph.raj/Documents/personal/pes/sem3/capstone_project/"
    "nse-lob-capstone/docs/project_report/appendix_tables.tex"
)


def pull(area, name):
    return pd.read_csv(
        io.BytesIO(
            s3.get_object(Bucket=B, Key=f"experiments/{area}/results/{name}")[
                "Body"
            ].read()
        )
    )


def esc(s):
    return str(s).replace("_", r"\_").replace("%", r"\%")


def longtable(df, cols, headers, aligns, caption, label, fmts=None):
    fmts = fmts or {}
    n = len(cols)
    out = [r"\begin{longtable}{@{}" + aligns + r"@{}}"]
    out.append(rf"\caption{{{caption}}}\label{{{label}}}\\")
    out.append(r"\toprule")
    out.append(" & ".join(headers) + r" \\")
    out.append(r"\midrule")
    out.append(r"\endfirsthead")
    out.append(
        rf"\multicolumn{{{n}}}{{@{{}}l}}{{\small\itshape \tablename~\thetable\ (continued)}}\\"
    )
    out.append(r"\toprule")
    out.append(" & ".join(headers) + r" \\")
    out.append(r"\midrule")
    out.append(r"\endhead")
    out.append(
        rf"\midrule \multicolumn{{{n}}}{{r@{{}}}}{{\small continued on next page}}\\"
    )
    out.append(r"\endfoot")
    out.append(r"\bottomrule")
    out.append(r"\endlastfoot")
    for _, r in df.iterrows():
        vals = []
        for c in cols:
            v = r[c]
            if c in fmts:
                vals.append(fmts[c](v))
            elif isinstance(v, float):
                vals.append(f"{v:.4f}")
            else:
                vals.append(esc(v))
        out.append(" & ".join(vals) + r" \\")
    out.append(r"\end{longtable}")
    return "\n".join(out)


def k_params(v):  # 70000 -> 70k, 1803728 -> 1.80M
    v = int(v)
    return f"{v / 1e6:.2f}M" if v >= 1e6 else f"{v / 1e3:.0f}k"


sections = [
    r"\appendix",
    r"\section{Detailed Result Tables}",
    "This appendix lists the complete per-run results behind the summary tables in Chapter~3. "
    "All NSE runs use Scheme~A (fixed $\\alpha{=}10^{-5}$) unless noted; metrics are on the held-out "
    "test split. Checkpoints and metrics JSON for every run are versioned on S3 under "
    "\\texttt{experiments/<area>/}.",
]

# ---- A. NSE Scheme-A matrix (32) ----
nse = pull("nse", "nse_matrix.csv").sort_values(["symbol", "model", "horizon"])
nse["lift"] = nse["test_weighted_f1"] - nse[
    ["baseline_majority_wf1", "baseline_stat_wf1", "baseline_random_wf1"]
].max(axis=1)
sections.append(r"\subsection{NSE Scheme-A transfer matrix (32 runs)}")
sections.append(
    longtable(
        nse,
        [
            "model",
            "symbol",
            "horizon",
            "n_params",
            "test_weighted_f1",
            "test_macro_f1",
            "test_accuracy",
            "test_mcc",
            "lift",
        ],
        ["Model", "Symbol", "$k$", "Params", "wF1", "mF1", "Acc", "MCC", "Lift"],
        "lllrrrrrr",
        "NSE Scheme-A: all four models $\\times$ two instruments $\\times$ four horizons. Lift = wF1 minus the best naive baseline.",
        "tab:app-nse",
        {"n_params": k_params, "horizon": lambda v: str(int(v))},
    )
)

# ---- B. Tier-A feature ablation (12) ----
fa = pull("feature_ablation", "feature_ablation.csv").sort_values(
    ["symbol", "horizon", "feature_set"]
)
sections.append(r"\subsection{Tier-A microstructure feature ablation (12 runs)}")
sections.append(
    longtable(
        fa,
        [
            "model",
            "symbol",
            "feature_set",
            "horizon",
            "n_features",
            "n_params",
            "test_weighted_f1",
            "test_macro_f1",
            "test_accuracy",
        ],
        ["Model", "Symbol", "Feat.\\ set", "$k$", "$F$", "Params", "wF1", "mF1", "Acc"],
        "lllrrrrrr",
        "Tier-A feature ablation (MambaLOB and a TLOB spot-check, NIFTY).",
        "tab:app-feat",
        {
            "n_params": k_params,
            "horizon": lambda v: str(int(v)),
            "n_features": lambda v: str(int(v)),
        },
    )
)

# ---- C. Tier-B architecture (20) ----
arch = pull("architecture", "architecture.csv").sort_values(
    ["symbol", "horizon", "model"]
)
sections.append(r"\subsection{Tier-B architecture comparison (20 runs)}")
sections.append(
    longtable(
        arch,
        [
            "model",
            "symbol",
            "horizon",
            "n_params",
            "test_weighted_f1",
            "test_macro_f1",
            "test_accuracy",
            "test_mcc",
            "train_time_s",
        ],
        ["Model", "Symbol", "$k$", "Params", "wF1", "mF1", "Acc", "MCC", "Train (s)"],
        "lllrrrrrr",
        "Tier-B: improved MambaLOB variants vs.\\ TLOB on the \\texttt{all} feature set.",
        "tab:app-arch",
        {
            "n_params": k_params,
            "horizon": lambda v: str(int(v)),
            "train_time_s": lambda v: f"{v:.0f}",
        },
    )
)

# ---- D. Tier-C multi-seed (48) ----
tc = pull("tier_c", "tier_c.csv").sort_values(
    ["symbol", "horizon", "model", "feature_set", "seed"]
)
tc["cfg"] = tc["model"] + "/" + tc["feature_set"]
sections.append(r"\subsection{Tier-C multi-seed study (48 runs)}")
sections.append(
    longtable(
        tc,
        [
            "cfg",
            "symbol",
            "horizon",
            "seed",
            "test_weighted_f1",
            "test_macro_f1",
            "test_accuracy",
            "test_mcc",
        ],
        ["Model/feat.", "Symbol", "$k$", "Seed", "wF1", "mF1", "Acc", "MCC"],
        "lllrrrrr",
        "Tier-C: headline configurations over 3 seeds (significance/CIs in Table~\\ref{tab:tierc-sig}).",
        "tab:app-tierc",
        {"horizon": lambda v: str(int(v)), "seed": lambda v: str(int(v))},
    )
)

text = "\n\n".join(sections) + "\n"
open(OUT, "w").write(r"{\small" + "\n" + text + "}\n")
print("wrote", OUT)
print(f"rows: nse={len(nse)} feat={len(fa)} arch={len(arch)} tierc={len(tc)}")
