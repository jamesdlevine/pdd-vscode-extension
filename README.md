# PDD VS Code Extension

VS Code extension for [PDD (Prompt-Driven Development)](https://github.com/promptdriven/pdd).

## Quick Setup (one command)

Requires [conda](https://docs.conda.io/en/latest/miniconda.html) and VS Code.

```bash
curl -fsSL https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/setup-tester.sh | bash
```

This creates a `pdd` conda environment with all dependencies and installs the extension.

## Manual Setup

### Step 1: Create conda environment

```bash
conda create -n pdd python=3.12 -y
conda activate pdd
```

### Step 2: Install Python packages

```bash
# PDD CLI (from PyPI)
pip install pdd-cli

# PDD server + manager (from TestPyPI)
pip install -r https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/tester-install.txt
```

### Step 3: Install VS Code extension

Download the latest `.vsix` from the [Releases](https://github.com/jamesdlevine/pdd-vscode-extension/releases) page, then:

```bash
code --install-extension pdd-vscode-0.1.0.vsix
```

## VS Code Settings

| Setting | Default | Description |
|---|---|---|
| `pdd.condaEnvironment` | `"pdd"` | Conda env name. Set to `""` for system Python / venv. |

## Verifying

```bash
conda activate pdd
python -c "import pddm; print(pddm.__file__)"
python -c "import pdd_server; print(pdd_server.__file__)"
pdd --version
```

In VS Code, open the Output panel and select "PDD" to see sidecar logs.
