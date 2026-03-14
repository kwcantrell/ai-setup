# Git Best Practices Reference Guide 📚

## Table of Contents

- [Workflow Strategies](#workflow-strategies)
- [Branch Naming Conventions](#branch-naming-conventions)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Code Review Best Practices](#code-review-best-practices)
- [Conflict Resolution](#conflict-resolution)
- [Rebasing vs Merging](#rebasing-vs-merging)
- [Git Maintenance Tools](#git-maintenance-tools)
- [Large-Scale Repository Management](#large-scale-repository-management)

---

## Workflow Strategies

| Strategy | Best For | Branch Lifespan | Merge Frequency |
|----------|----------|-----------------|-----------------|
| **Trunk-Based Development** | CI/CD, frequent deployments | Hours to days | Many times/day |
| **GitHub Flow** | Web projects, startups | Days to weeks | Moderate |
| **Feature Branch Workflow** | Teams with moderate cadence | Days to a week | Regular |
| **GitFlow** | Release-heavy projects | Weeks to months | Scheduled |

**Recommendation**: For most modern teams in 2025-2026: **Trunk-based Development** with GitHub Flow principles.

---

## Branch Naming Conventions

```bash
<type>/<description>
# Examples:
feat/user-authentication
fix/header-navigation-bug
docs/api-documentation
refactor/order-validation
perf/query-batching
test/auth-suite
chore/update-dependencies
style/formatting-fix
```

**Type Prefix Guidelines:**
- `feat/` - New feature
- `fix/` - Bug fix (user-facing)
- `docs/` - Documentation
- `refactor/` - Code reorganization
- `perf/` - Performance improvements
- `test/` - Test additions/modifications
- `chore/` - Maintenance tasks
- `style/` - Formatting only

---

## Commit Message Guidelines

### Conventional Commits Format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Atomic Commit Principles:**
- ✓ Contain ONE logical change only
- ✓ All files changed are directly related
- ✓ Be independently testable and reversible
- ✓ Rule: if it could be reverted separately, it's too big

---

## Code Review Best Practices

### PR Title Guidelines:
- Short and descriptive (under 72 characters)
- Include ticket/issue reference when applicable
- Use conventional commit prefix (`feat:`, `fix:`, etc.)

### Reviewer Checklist:
- [ ] Code is self-documenting with clear naming
- [ ] Error handling covers all failure paths
- [ ] No sensitive information exposed
- [ ] Tests cover happy path and edge cases
- [ ] Functions under 50 lines preferred (cognitive load)
- [ ] Related issues referenced and closed

---

## Conflict Resolution

**When conflicts occur:**
1. Don't panic - small conflicts are normal
2. Identify conflicted files: `git status`
3. View unmerged files: `git diff --name-only --diff-filter=U`
4. Resolve conflicts (look for markers: `<<<<<<<`, `=====`, `>>>>>>`)
5. Test immediately after resolving

**Merge Strategies:**
| Strategy | Command | Use Case |
|----------|---------|----------|
| **Fast-forward** | `git pull --ff-only` | When main is stable |
| **Merge commit** | `git merge origin/main` | Preserves feature branch history |

---

## Rebasing vs Merging

**When to Rebase:**
- ✓ Personal/local branches (before pushing)
- ✓ Feature branches before PR submission
- ✓ Keeping history linear

**Never Rebase:**
- ✗ Public/shared branches (`main`, `develop`)
- ✗ Branches with open PRs from others
- ✗ Tags or release commits

---

## Git Maintenance Tools

### Git Blame:
```bash
git blame --porcelain <file>          # View author and date
git blame -L 10,20 src/component.ts   # Line range
git blame -w --full-diff path/to/file.txt  # Show all changes
```

### Git Bisect: (Finding bug introductions)
```bash
git checkout v1.0
git bisect bad        # Mark bad version
git checkout v0.5
git bisect good       # Mark good version
git bisect            # Let git find the culprit
```

---

## Git Hooks and Pre-commit Checks

### Recommended Tools:
- **[Husky](https://typicode.github.io/husky/)** - Hook management for npm/yarn
- **[commitlint](https://commitlint.js.org/)** - Commit message enforcement
- **[lint-staged](https://github.com/okonet/lint-staged)** - Run hooks on staged files only

---

## Large-Scale Repository Management

**Git LFS** (Large File Storage) - Use for binaries, images, videos:
```bash
git lfs install
git lfs track "*.png"
git lfs track "*.mp4"
```

### Sizing Guidelines:
| Metric | Recommendation |
|--------|----------------|
| Files per commit | < 50 files |
| Binary file size | < 5 MB (use LFS for larger) |
| Total repo size | Monitor growth, archive old versions |

---

## Branch Protection Rules

**Common Policies:**
| Rule | Setting | Rationale |
|------|---------|----------|
| Required PR review | 1+ reviewers | Ensures code quality |
| Status checks passing | Required (CI) | Prevents broken builds |
| Branch restriction | Protected only | Enforce workflow |
| Force pushes allowed | Disabled on main | Preserve history integrity |

---

## Anti-Patterns to Avoid

❌ Long-running branches (weeks/months)
❌ Large commits (>50 files)
❌ Mixing concerns in one commit
❌ Force pushing after others worked on your branch
❌ Cherry-picking for normal merges
❌ Reviewing code without reading PR description

---

## Summary Checklist for Teams

- [ ] Adopt trunk-based development (branches hours to days)
- [ ] Use conventional commits (`feat:`, `fix:`, etc.)
- [ ] Write atomic, reversible commits (one concern per commit)
- [ ] Keep PRs focused and small (<500 lines changed preferred)
- [ ] Require passing CI checks before merging
- [ ] Review code within SLA (e.g., 24 hours)
- [ ] Use branch names with type prefixes (`feat/`, `fix/`)
- [ ] Squash commits before final merge to main
- [ ] Document breaking changes in commit message footer

---

## Quick Reference Commands

```bash
# Create and setup branch
git checkout -b feat/description
git remote add upstream <url>  # If using fork workflow

# Keep local up-to-date before starting work
git fetch upstream
git rebase upstream/main

# Make changes, stage, commit atomically
git add .
git commit -m "feat: <concise description>"

# Test locally
# ... your test commands ...

# Rebase commits to squash (before push!)
git rebase -i HEAD~3  # Edit last N commits

# Clean up before final push
git rebase upstream/main
```

---

## License

This document follows [Conventional Commits](https://www.conventionalcommits.org/) specification.
