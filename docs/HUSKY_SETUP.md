# Husky Setup Guide

This guide helps you set up Git hooks with Husky to enforce commit message standards and pre-commit checks.

## Installation

```bash
# Install Husky globally (if not already installed)
npm install -g husky

# In your project:
npm init -y  # If package.json doesn't exist
npm install --save-dev husky lint-staged commitlint
```

## Configuration

Create `.huskyrc` or add to `package.json`:

### package.json
```json
{
  "scripts": {
    "prepare": "husky",
    "pre-commit": "lint-staged"
  }
}
```

### .huskyrc (alternative)
```toml
precommit = "npx lint-staged"
prepush = 'npm run build:checks'
```

## Pre-commit Hooks

Create `.husky/pre-commit`:

```bash
#!/usr/bin/env sh

# Get all staged files that match lint patterns
files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(js|ts|jsx|tsx|py|java|go)$') || true

if [ ! "$files" ]; then
  exit 0
fi

# Run your linter/formatter on staged files
echo "Linting files:"
echo "$files" | xargs --max-procs 4 eslint --fix --quiet

git add -p
```

## Commitlint

Create `.husky/commit-msg`:

```bash
#!/usr/bin/env sh

echo "Checking commit message..."

npx commitlint -e "$1"

exit $?
```

## Recommended Workflow

1. **Make changes** → `git add .`
2. **Run linters** on staged files (lint-staged handles this)
3. **Commit with conventional format**: `git commit -m "feat: add login button"`
4. **Push to remote**

## Useful Husky Commands

```bash
# Install hooks
npx husky install

# Run specific hook
npx husky run pre-commit

# Remove all hooks
rm -rf .husky
npm uninstall husky
```

## Next Steps

- Configure your linter (ESLint, Prettier, etc.)
- Set up commitlint with custom rules
- Add push hooks to prevent pushing without tests
