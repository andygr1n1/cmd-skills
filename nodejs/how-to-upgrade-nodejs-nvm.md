# How to Upgrade Node.js and Use Latest Stable Version

This guide shows how to upgrade Node.js using **nvm** (Node Version Manager) and ensure it’s used system-wide.

---

## Prerequisites

- **nvm** must be installed. If not:

  ```bash
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  ```

  Then restart your terminal or run `source ~/.zshrc`.

---

## Step-by-Step Instructions

### Step 1: Check your current Node version

```bash
node -v
```

### Step 2: Install the latest LTS (recommended for stability)

```bash
nvm install --lts
```

Or install the latest current release:

```bash
nvm install node
```

### Step 3: Set the new version as default

This makes the version used automatically in every new terminal:

```bash
nvm alias default <version>
```

Example for v24.13.1:

```bash
nvm alias default 24.13.1
```

### Step 4: Switch to the new version in this terminal

```bash
nvm use default
```

### Step 5: Verify the installation

```bash
node -v
npm -v
```

### Step 6: Ensure nvm uses the default in every new shell

Add this line to `~/.zshrc` right after the nvm loading block:

```bash
[ -n "$(nvm version default 2>/dev/null)" ] && nvm use default --silent
```

Your nvm section should look like:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -n "$(nvm version default 2>/dev/null)" ] && nvm use default --silent
```

Then reload your config:

```bash
source ~/.zshrc
```

---

## Quick Reference Commands

| Command | Description |
|--------|-------------|
| `nvm ls` | List installed versions |
| `nvm ls-remote --lts` | List available LTS versions |
| `nvm install --lts` | Install latest LTS |
| `nvm install node` | Install latest current |
| `nvm alias default <version>` | Set default version |
| `nvm use <version>` | Use a specific version |
| `nvm current` | Show active version |

---

## Common Issues

### Homebrew Node overrides nvm

If `/opt/homebrew/bin` is added to `PATH` after nvm in your `~/.zshrc`, Homebrew’s Node may be used instead of nvm’s. Fix by adding the `nvm use default --silent` line (Step 6 above) so nvm-managed Node is used.

### Vite / other tools need newer Node

Vite requires Node.js 20.19+ or 22.12+. Use Node 22.12+ or any LTS version (e.g. 24.x) from the steps above.

---

## Notes

- **LTS** (Long Term Support) is best for stable use.
- **Current** is the latest release and may have newer features.
- The default version is stored in nvm and reused in every new terminal.
