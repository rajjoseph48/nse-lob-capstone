"""Generate EDA figures for the report from real NSE Dhan data (NIFTY).

Pulls a few training-window days from S3, then plots:
  1. label distribution by horizon (Scheme A) -- stacked bars
  2. inter-tick gap distribution (log) with CV annotation
  3. relative-spread distribution (bps) with median annotation
  4. an intraday mid-price trace
Saves PNGs into docs/project_report/figures/.
"""

import os
import sys
import io
import numpy as np
import pandas as pd
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import boto3

MODELING = "/Users/joseph.raj/Documents/personal/pes/sem3/capstone_project/nse-lob-capstone/modeling"
sys.path.insert(0, MODELING)
from nse_dataset import _make_labels  # reuse the exact pipeline labeller

OUT = os.path.join(
    MODELING,
    "..",
    "docs",
    "project_report",
    "figures",
)
OUT = os.path.abspath(OUT)
BUCKET, REGION = "lob-capstone-data", "ap-south-2"
SYMBOL = "NIFTY"
DAYS = ["20260512", "20260513", "20260514", "20260515", "20260518"]  # 5 training days

s3 = boto3.client("s3", region_name=REGION)


def load_day(d):
    key = f"lob-data/dhan/lob_dhan_{d}.parquet"
    buf = io.BytesIO(s3.get_object(Bucket=BUCKET, Key=key)["Body"].read())
    df = pd.read_parquet(buf)
    # front-month: rows whose symbol starts with the root
    df = df[df["symbol"].astype(str).str.startswith(SYMBOL)].copy()
    df = df[df["bid_price_1"] < df["ask_price_1"]]  # drop crossed quotes
    df["ts"] = pd.to_datetime(df["timestamp"], format="ISO8601")
    df = df.sort_values("ts").reset_index(drop=True)
    return df


print("loading", len(DAYS), "days from S3 ...")
days = {d: load_day(d) for d in DAYS}
for d, df in days.items():
    print(f"  {d}: {len(df):,} NIFTY events")

# concat with per-day segment ids (labels never cross a day)
frames, segs = [], []
for i, d in enumerate(DAYS):
    frames.append(days[d])
    segs.append(np.full(len(days[d]), i))
df = pd.concat(frames, ignore_index=True)
seg = np.concatenate(segs)
mid = ((df["bid_price_1"] + df["ask_price_1"]) / 2).values
spread = (df["ask_price_1"] - df["bid_price_1"]).values
rel_spread_bps = spread / mid * 1e4

# ---- 1. label distribution by horizon ----
CLASSES = ["Down", "Stat", "Up"]
COLORS = ["#d62728", "#7f7f7f", "#2ca02c"]
horizons = [10, 20, 50, 100]
props = []
for k in horizons:
    lab = _make_labels(mid, k=k, alpha=1e-5, seg=seg)
    lab = lab[lab >= 0]
    c = np.bincount(lab, minlength=3) / len(lab) * 100
    props.append(c)
props = np.array(props)  # (n_horizons, 3)
fig, ax = plt.subplots(figsize=(6.2, 3.6))
bottom = np.zeros(len(horizons))
x = np.arange(len(horizons))
for c in range(3):
    ax.bar(x, props[:, c], bottom=bottom, label=CLASSES[c], color=COLORS[c])
    for xi in x:
        if props[xi, c] > 4:
            ax.text(
                xi,
                bottom[xi] + props[xi, c] / 2,
                f"{props[xi, c]:.0f}%",
                ha="center",
                va="center",
                fontsize=8,
                color="white",
            )
    bottom += props[:, c]
ax.set_xticks(x)
ax.set_xticklabels([f"k={k}" for k in horizons])
ax.set_ylabel("class share (%)")
ax.set_ylim(0, 100)
ax.set_title(f"{SYMBOL} — Scheme A label distribution by horizon")
ax.legend(ncol=3, loc="upper center", bbox_to_anchor=(0.5, -0.12), frameon=False)
fig.tight_layout()
fig.savefig(f"{OUT}/eda_label_dist.png", dpi=150, bbox_inches="tight")
plt.close(fig)
print("wrote eda_label_dist.png", props.round(1).tolist())

# ---- 2. inter-tick gap distribution ----
gaps = []
ev_per_min = []
for d in DAYS:
    g = days[d]["ts"].diff().dt.total_seconds().dropna().values
    g = g[
        (g > 0) & (g < 300)
    ]  # exclude only nonpositive + genuine feed outages (>5 min)
    gaps.append(g)
    span_min = (days[d]["ts"].iloc[-1] - days[d]["ts"].iloc[0]).total_seconds() / 60
    ev_per_min.append(len(days[d]) / span_min)
gaps = np.concatenate(gaps)
cv = gaps.std() / gaps.mean()
print(
    f"  events/min per day: {[round(e) for e in ev_per_min]} (mean {np.mean(ev_per_min):.0f})"
)
print(
    f"  gap mean={gaps.mean():.3f}s p99={np.percentile(gaps, 99):.2f}s max={gaps.max():.1f}s"
)
fig, ax = plt.subplots(figsize=(6.2, 3.6))
ax.hist(
    gaps,
    bins=np.logspace(np.log10(max(gaps.min(), 1e-3)), np.log10(gaps.max()), 60),
    color="#1f77b4",
    edgecolor="none",
)
ax.set_xscale("log")
ax.axvline(
    np.median(gaps), color="k", ls="--", lw=1, label=f"median {np.median(gaps):.2f}s"
)
ax.set_xlabel("inter-tick gap (s, log scale)")
ax.set_ylabel("count")
ax.set_title(f"{SYMBOL} — inter-tick gap (median {np.median(gaps):.2f}s, CV={cv:.2f})")
ax.legend(frameon=False)
fig.tight_layout()
fig.savefig(f"{OUT}/eda_intertick.png", dpi=150, bbox_inches="tight")
plt.close(fig)
print(f"wrote eda_intertick.png  median={np.median(gaps):.3f}s CV={cv:.2f}")

# ---- 3. relative-spread distribution (bps) ----
rs = rel_spread_bps[(rel_spread_bps > 0) & (rel_spread_bps < 20)]
fig, ax = plt.subplots(figsize=(6.2, 3.6))
ax.hist(rs, bins=60, color="#9467bd", edgecolor="none")
ax.axvline(
    np.median(rs), color="k", ls="--", lw=1, label=f"median {np.median(rs):.2f} bps"
)
ax.set_xlabel("relative spread (bps)")
ax.set_ylabel("count")
ax.set_title(f"{SYMBOL} — relative bid–ask spread")
ax.legend(frameon=False)
fig.tight_layout()
fig.savefig(f"{OUT}/eda_spread.png", dpi=150, bbox_inches="tight")
plt.close(fig)
print(f"wrote eda_spread.png  median={np.median(rs):.2f}bps")

# ---- 4. intraday mid-price trace (one day) ----
d0 = DAYS[0]
dd = days[d0]
mid0 = ((dd["bid_price_1"] + dd["ask_price_1"]) / 2).values
fig, ax = plt.subplots(figsize=(6.2, 3.2))
ax.plot(dd["ts"].values, mid0, color="#1f77b4", lw=0.8)
ax.set_xlabel("time (IST)")
ax.set_ylabel("mid-price (₹)")
ax.set_title(f"{SYMBOL} front-month mid-price — {d0[:4]}-{d0[4:6]}-{d0[6:]}")
fig.autofmt_xdate()
fig.tight_layout()
fig.savefig(f"{OUT}/eda_midprice.png", dpi=150, bbox_inches="tight")
plt.close(fig)
print(
    f"wrote eda_midprice.png  ({len(mid0):,} events, range {mid0.min():.0f}-{mid0.max():.0f})"
)
print("ALL EDA FIGURES WRITTEN to", OUT)
