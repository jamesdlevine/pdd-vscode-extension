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

```bash
# Download the latest .vsix
curl -fsSL -o pdd-vscode.vsix $(curl -fsSL https://api.github.com/repos/jamesdlevine/pdd-vscode-extension/releases/latest | python3 -c "import sys,json; print([a['browser_download_url'] for a in json.load(sys.stdin)['assets'] if a['name'].endswith('.vsix')][0])")

# Install it
code --install-extension pdd-vscode.vsix
```

### Step 3: Tell VS Code which Python environment to use

The extension needs to know where you installed the Python packages.
It checks these in order — you only need to do **one**:

#### Option A: Environment variable (recommended)

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
export PDD_EXTENSION_SERVER_CONDA=myenv
```

Replace `myenv` with the name of the conda environment you installed into.
Restart VS Code after adding this.

#### Option B: VS Code setting (per-user)

Open `~/.config/Code/User/settings.json` and add:

```json
{
  "pdd.condaEnvironment": "myenv"
}
```

Or via the VS Code UI: open Settings (Ctrl+,), search for `pdd.condaEnvironment`,
and enter your environment name.

#### Option C: VS Code setting (per-project)

Create `.vscode/settings.json` in your project folder:

```json
{
  "pdd.condaEnvironment": "myenv"
}
```

This is useful if different projects use different environments.

#### Option D: No configuration needed

If you installed the packages into your **system Python** or a **venv that is
already active** when VS Code starts, no configuration is needed. Just make sure
`pdd.condaEnvironment` is empty (the default).

## Verifying

```bash
conda activate myenv
python -c "import pddm; print(pddm.__file__)"
python -c "import pdd_server; print(pdd_server.__file__)"
pdd --version
```

In VS Code, open the Output panel (Ctrl+Shift+U) and select "PDD" to see sidecar logs.

## Troubleshooting

If the extension can't start the sidecar, it will show an error dialog with two buttons:

- **Open Settings** — jumps directly to the `pdd.condaEnvironment` setting
- **Show Output** — opens the PDD log so you can see what went wrong
