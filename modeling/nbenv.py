"""
Notebook environment helpers — make the notebooks run on **Kaggle** as well as Colab.

After the repo is cloned and `modeling/` is on sys.path, notebooks do:
    from nbenv import get_secret, find_fi2010, detect_env

Differences handled:
  - Secrets: Kaggle `UserSecretsClient` vs Colab `userdata` vs plain env vars.
  - FI-2010 location: Kaggle mounts an attached dataset read-only under /kaggle/input
    (no download); Colab downloads via the Kaggle CLI into ./fi2010_data.
"""

from __future__ import annotations

import os
import pathlib
import zipfile


def detect_env() -> str:
    """Return 'kaggle', 'colab', or 'local'."""
    if os.path.isdir("/kaggle"):
        return "kaggle"
    try:
        import google.colab  # noqa: F401

        return "colab"
    except Exception:
        return "local"


def get_secret(name: str) -> str:
    """Read a secret: Kaggle UserSecrets -> Colab userdata -> env var. '' if absent."""
    try:
        from kaggle_secrets import UserSecretsClient

        v = UserSecretsClient().get_secret(name)
        if v:
            return v
    except Exception:
        pass
    try:
        from google.colab import userdata

        v = userdata.get(name)
        if v:
            return v
    except Exception:
        pass
    return os.environ.get(name, "")


def _zscore_under(root) -> pathlib.Path | None:
    root = pathlib.Path(root)
    if not root.exists():
        return None
    if (root / "NoAuction_Zscore_Training").exists():
        return root
    for p in root.rglob("*"):
        if p.is_dir() and p.name.lower() == "noauction_zscore_training":
            return p.parent
    for p in root.rglob("*"):
        if p.is_dir() and "zscore" in p.name.lower() and "noauction" in p.name.lower():
            return p
    return None


def find_fi2010(roots=None) -> str:
    """Locate the NoAuction_Zscore folder across Kaggle/Colab locations.

    On **Kaggle**: attach the FI-2010 dataset (Add Data) — it mounts under /kaggle/input.
    On **Colab**: the Kaggle CLI downloads into ./fi2010_data (we also extract any nested zip).
    Returns the folder path as a string, or '' if not found.
    """
    roots = roots or ["/kaggle/input", "fi2010_data", "."]
    dd = pathlib.Path("fi2010_data")
    if dd.exists():
        for z in dd.rglob("*.zip"):  # extract a nested zip the CLI left behind
            try:
                with zipfile.ZipFile(z) as zf:
                    zf.extractall(z.parent)
            except Exception:
                pass
    for r in roots:
        found = _zscore_under(r)
        if found:
            return str(found)
    return ""
