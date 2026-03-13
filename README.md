# PDD VS Code Extension

VS Code extension for [PDD (Prompt-Driven Development)](https://github.com/promptdriven/pdd).

## Quick Setup

Activate your Python environment first, then:

```bash
conda activate myenv  # or: source .venv/bin/activate
curl -fsSL https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/setup-tester.sh | bash
```

This installs all Python dependencies and the VS Code extension.

## Manual Setup

### Step 1: Install Python packages

Activate your preferred Python 3.10+ environment, then:

```bash
# PDD CLI (from PyPI)
pip install pdd-cli

# PDD server + manager (from TestPyPI)
pip install -r https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/tester-install.txt
```

### Step 2: Install VS Code extension

Download the latest `.vsix` from the [Releases](https://github.com/jamesdlevine/pdd-vscode-extension/releases) page, then:

```bash
code --install-extension pdd-vscode-0.1.0.vsix
```

## VS Code Settings

| Setting | Default | Description |
|---|---|---|
| `pdd.condaEnvironment` | `"pdd"` | Conda env name. Set to `""` for system Python / venv. |

Set this to match the environment you installed into.

## Verifying

```bash
python -c "import pddm; print(pddm.__file__)"
python -c "import pdd_server; print(pdd_server.__file__)"
pdd --version
```

In VS Code, open the Output panel and select "PDD" to see sidecar logs.
