#!/bin/bash
# ========================================
# Git Hooks Template
# ========================================
# Copy to .git/hooks/ or use npx husky
# ========================================

# ============================================================================
# PRE-COMMIT HOOK
# Runs before each commit to catch issues early
# ============================================================================
. git/pre-commit

# Check if we have files staged
files=$(git diff --cached --name-only --diff-filter=ACM) || exit 0

if [ -z "$files" ]; then
    exit 0
fi

echo "🔍 Checking staged files..."
echo "Files:"
echo "$files"

# Custom checks (add/remove as needed)

# Check for sensitive data
for file in $files; do
    if grep -qE "(password|secret|token)\s*[:=]\s*[\'\"\w]{8,}" "$file" 2>/dev/null; then
        echo "❌ Potential sensitive data found in: $file"
        exit 1
    fi
done

# Check for TODO/FIXME comments (optional)
if grep -l "TODO\|FIXME" "$files"; then
    echo "⚠️  TODO/FIXME comments detected in:"
    grep -r --color=never -l "TODO\|FIXME" "$files"
fi

echo "✅ Pre-commit checks passed!"
exit 0


# ============================================================================
# PRE-PUSH HOOK
# Runs before pushing to remote (can block pushes if conditions not met)
# ============================================================================
. git/pre-push

# Test suite (optional - only run for main branches)
remote_branch=$(git push origin $(git rev-parse --abbrev-ref HEAD)+:refs/remotes/origin/* | sed 's/^  -> //' 2>/dev/null || echo "")

if [ "$remote_branch" == "main" ] || [ "$remote_branch" == "master" ]; then
    echo "🧪 Running test suite before push to main..."

    # Add your test commands here
    # npm test 2>&1 | tee /tmp/test-output.log
    # npx jest --passWithNoTests

    if [ $? -ne 0 ]; then
        echo "❌ Tests failed. Please fix before pushing to main."
        exit 1
    fi
fi

# Prevent force pushes after others have pushed
if git rev-parse HEAD@{1} 2>/dev/null; then
    # Check if anyone else has pushed recently
    recent_commits=$(git shortlog -s --since='10 minutes ago' origin/main | wc -l)
    if [ "$recent_commits" -gt 5 ]; then
        echo "⚠️  Many commits on main since you started. Force push may cause conflicts."
        echo "Consider resolving conflicts locally first."
    fi
fi

echo "✅ Pre-push checks passed!"
exit 0


# ============================================================================
# POST-REBASE HOOK (Optional)
# Ensures branch is up-to-date after rebase
# ============================================================================
. git/post-rebase

if [ $? -eq 0 ]; then
    echo "✅ Rebase completed successfully"

    # Optionally sync with latest main
    git fetch origin main:refs/remotes/origin/main

    echo "Branch synced with remote."
else
    echo "⚠️  Rebase had conflicts or issues. Check the output above."
fi

exit 0


# ============================================================================
# COMMIT-MSG HOOK
# Validates commit message format before commit is finalized
# ============================================================================
. git/commit-msg

COMMIT_MSG=$1

# Check message isn't empty
if [ -z "$COMMIT_MSG" ]; then
    echo "❌ Commit message cannot be empty!"
    exit 1
fi

# Parse first line (subject)
SUBJECT=$(echo "$COMMIT_MSG" | head -n 1)

# Enforce conventional commits (optional)
if ! echo "$SUBJECT" | grep -qE "^(feat|fix|docs|style|refactor|perf|test|chore)(\([^)]+\))?: "; then
    echo "❌ Commit message must follow conventional commit format."
    echo "Example: feat(auth): add login button"
    exit 1
fi

# Check subject length (max 72 chars recommended)
LENGTH=${#SUBJECT}
if [ $LENGTH -gt 72 ]; then
    echo "❌ Commit subject too long ($LENGTH > 72 chars)"
    exit 1
fi

echo "✅ Commit message format valid!"
exit 0


# ============================================================================
# PRE-REBASE HOOK (Optional)
# Ensures branch is clean and up-to-date before starting rebase
# ============================================================================
. git/pre-rebase

# Check for uncommitted changes
if ! git diff --quiet; then
    echo "⚠️  You have local changes not committed"
    echo "Consider committing or stashing before rebasing."
fi

# Ensure you're on a tracking branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "main" ] && [ "$BRANCH" != "master" ]; then
    # Rebase is being requested, which is normal for feature branches
    :
else
    echo "❌ Do not rebase main/master branch!"
    exit 1
fi

echo "✅ Ready to rebase."
exit 0


# ============================================================================
# USAGE: To install these hooks
#
#   mkdir -p .git/hooks
#   cp git/pre-commit .git/hooks/
#   chmod +x .git/hooks/pre-commit
#
# Or use Husky (recommended):
#   npx husky install
#   # Creates .husky directory with proper setup
# ============================================================================
