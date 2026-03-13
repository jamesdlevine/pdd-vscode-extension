#!/usr/bin/env bash
#
# One-command setup for PDD testers.
# Creates a conda environment with pdd-cli, pdd-manager, and pdd-server,
# then installs the VS Code extension.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/setup-tester.sh | bash
#
# Or download and run:
#   ./setup-tester.sh
#
set -euo pipefail

ENV_NAME="pdd"
PYTHON_VERSION="3.12"
REPO="jamesdlevine/pdd-vscode-extension"

echo "==> PDD Tester Setup"
echo ""

# --- check prerequisites ---------------------------------------------------

if ! command -v conda &>/dev/null; then
  echo "ERROR: conda not found. Install miniconda first:"
  echo "  https://docs.conda.io/en/latest/miniconda.html"
  exit 1
fi

if ! command -v code &>/dev/null; then
  echo "WARNING: 'code' command not found. You'll need to install the .vsix manually."
fi

# --- create conda env if needed --------------------------------------------

if conda info --envs | grep -q "^${ENV_NAME} "; then
  echo "==> Conda env '$ENV_NAME' already exists, reusing it"
else
  echo "==> Creating conda env '$ENV_NAME' (Python $PYTHON_VERSION)"
  conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y
fi

echo ""

# --- install Python packages -----------------------------------------------

echo "==> Installing pdd-cli (from PyPI)"
conda run -n "$ENV_NAME" pip install --upgrade pdd-cli

echo ""
echo "==> Installing pdd-server + pdd-manager (from TestPyPI)"
conda run -n "$ENV_NAME" pip install \
  --index-url https://test.pypi.org/simple/ \
  --extra-index-url https://pypi.org/simple/ \
  pdd-server

echo ""

# --- install VS Code extension ---------------------------------------------

echo "==> Downloading latest VS Code extension"
VSIX_URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | python3 -c "import sys,json; assets=json.load(sys.stdin).get('assets',[]); vsix=[a for a in assets if a['name'].endswith('.vsix')]; print(vsix[0]['browser_download_url'] if vsix else '')")

if [ -z "$VSIX_URL" ]; then
  echo "WARNING: No .vsix found in latest release."
  echo "  Check https://github.com/$REPO/releases"
else
  VSIX_FILE="/tmp/pdd-vscode.vsix"
  curl -fsSL -o "$VSIX_FILE" "$VSIX_URL"

  if command -v code &>/dev/null; then
    code --install-extension "$VSIX_FILE"
    echo "  Extension installed."
  else
    echo "  Downloaded to: $VSIX_FILE"
    echo "  Install manually: code --install-extension $VSIX_FILE"
  fi
fi

echo ""

# --- verify ----------------------------------------------------------------

echo "==> Verifying install"
conda run -n "$ENV_NAME" python -c "import pddm; print(f'  pddm:       {pddm.__file__}')"
conda run -n "$ENV_NAME" python -c "import pdd_server; print(f'  pdd_server: {pdd_server.__file__}')"
conda run -n "$ENV_NAME" python -c "import pdd; print(f'  pdd-cli:    {pdd.__file__}')"

echo ""
echo "============================================"
echo "  Setup complete!"
echo "============================================"
echo ""
echo "  Conda env:  $ENV_NAME"
echo "  Activate:   conda activate $ENV_NAME"
echo ""
echo "  In VS Code, set pdd.condaEnvironment to \"$ENV_NAME\""
echo "  Then open a folder with a .pdd/ project."
echo ""
