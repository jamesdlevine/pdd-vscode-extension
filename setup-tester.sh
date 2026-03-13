#!/usr/bin/env bash
#
# Install PDD packages into the current Python environment
# and install the VS Code extension.
#
# Usage:
#   conda activate myenv   # or: source .venv/bin/activate
#   curl -fsSL https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/setup-tester.sh | bash
#
set -euo pipefail

REPO="jamesdlevine/pdd-vscode-extension"

echo "==> PDD Tester Setup"
echo ""

# --- check prerequisites ---------------------------------------------------

if ! command -v python3 &>/dev/null; then
  echo "ERROR: python3 not found."
  exit 1
fi

PYTHON_PATH=$(which python3)
echo "  Python: $PYTHON_PATH ($(python3 --version 2>&1))"

if [ -n "${CONDA_DEFAULT_ENV:-}" ]; then
  echo "  Conda env: $CONDA_DEFAULT_ENV"
elif [ -n "${VIRTUAL_ENV:-}" ]; then
  echo "  Venv: $VIRTUAL_ENV"
else
  echo "  WARNING: No conda/venv active. Packages will install to system Python."
  read -p "  Continue? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted. Activate an environment first, then re-run."
    exit 1
  fi
fi

echo ""

# --- install Python packages -----------------------------------------------

echo "==> Installing pdd-cli (from PyPI)"
pip install --upgrade pdd-cli

echo ""
echo "==> Installing pdd-server + pdd-manager (from TestPyPI)"
pip install \
  --index-url https://test.pypi.org/simple/ \
  --extra-index-url https://pypi.org/simple/ \
  pdd-server

echo ""

# --- install VS Code extension ---------------------------------------------

echo "==> Downloading latest VS Code extension"
VSIX_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | python3 -c "import sys,json; assets=json.load(sys.stdin).get('assets',[]); vsix=[a for a in assets if a['name'].endswith('.vsix')]; print(vsix[0]['browser_download_url'] if vsix else '')")

if [ -z "$VSIX_URL" ]; then
  echo "  WARNING: No .vsix found in latest release."
  echo "  Check https://github.com/$REPO/releases"
else
  VSIX_FILE="/tmp/pdd-vscode.vsix"
  curl -fsSL -o "$VSIX_FILE" "$VSIX_URL"

  # Try known IDE CLI names, otherwise instruct manual install
  INSTALLED=false
  for cli in code cursor; do
    if command -v "$cli" &>/dev/null; then
      "$cli" --install-extension "$VSIX_FILE"
      echo "  Extension installed via $cli."
      INSTALLED=true
      break
    fi
  done

  if ! $INSTALLED; then
    echo "  Downloaded to: $VSIX_FILE"
    echo "  To install: open your IDE's Extensions panel (Ctrl+Shift+X),"
    echo "  click '...' > 'Install from VSIX...' and select the file."
  fi
fi

echo ""

# --- verify ----------------------------------------------------------------

echo "==> Verifying"
python3 -c "import pddm; print(f'  pddm:       {pddm.__file__}')"
python3 -c "import pdd_server; print(f'  pdd_server: {pdd_server.__file__}')"
python3 -c "import pdd; print(f'  pdd-cli:    {pdd.__file__}')"

echo ""
echo "  Done. In VS Code, set pdd.condaEnvironment to your env name"
echo "  (or \"\" if using a venv/system Python), then open a .pdd/ project."
echo ""
