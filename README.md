# PDD VS Code Extension

VS Code extension for [PDD (Prompt-Driven Development)](https://github.com/promptdriven/pdd).

## Install

### Prerequisites

- Python 3.10+ (conda or venv recommended)
- VS Code

### Step 1: Python packages

```bash
pip install -r https://raw.githubusercontent.com/jamesdlevine/pdd-vscode-extension/main/tester-install.txt
```

This installs `pdd-server` (which pulls in `pdd-manager`) from TestPyPI,
with regular PyPI as a fallback for transitive dependencies.

### Step 2: VS Code extension

Download the latest `.vsix` from the [Releases](https://github.com/jamesdlevine/pdd-vscode-extension/releases) page, then:

```bash
code --install-extension pdd-vscode-0.1.0.vsix
```

### Step 3: Open a PDD project

1. Open a folder containing a `.pdd/` project in VS Code
2. The PDD sidebar should appear automatically
3. If using conda, set `pdd.condaEnvironment` in VS Code settings to the env
   where you installed the packages (default: `"pdd"`)
4. If using system Python or a venv, set `pdd.condaEnvironment` to `""`

### Verifying the install

```bash
python -c "import pddm; print(pddm.__file__)"
python -c "import pdd_server; print(pdd_server.__file__)"
```

In VS Code, open the Output panel and select "PDD" to see sidecar logs.
