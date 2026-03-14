#!/usr/bin/env node

/**
 * Pre-commit Hook Template
 * =======================
 *
 * This hook runs before each commit to ensure code quality.
 * Install with: npm install -g husky && npx husky init
 *
 * Usage in package.json:
 *   "prepare": "husky install",
 *   "pre-commit": "lint-staged"
 */

const fs = require('fs');
const path = require('path');

/**
 * Check for sensitive information in staged files
 * Uses simple regex patterns (replace with proper secrets scanning)
 */
function checkSensitiveData() {
  const stagedFiles = [];
  try {
    execSync('git diff --cached --name-only', { stdio: 'pipe' });
  } catch (e) {
    // No changes staged
    return;
  }

  const files = e.stdout.toString().trim().split('\n');

  for (const file of files) {
    if (!file) continue;

    try {
      const content = fs.readFileSync(file, 'utf8');

      // Check patterns - customize for your project
      const sensitivePatterns = [
        /(?<!\/)(?:key|secret|token|password)\s*[:=]\s*[\'\"\w]+/i,
        /AKIA[0-9A-Z]{16}/,  // AWS Access Key
        /sk-[a-zA-Z0-9]{20,}/, // Stripe keys
        /api[_-]?key\s*[=:]\s*['"]?[\w./-]+['"]/i,
      ];

      for (const pattern of sensitivePatterns) {
        if (pattern.test(content)) {
          console.log(`⚠️  Potential sensitive data in: ${file}`);
          return false;
        }
      }
    } catch (e) {
      // Skip unreadable files
    }
  }

  return true;
}

/**
 * Check commit message is not empty
 */
function checkCommitMessage() {
  try {
    const shortLog = execSync('git log -1 --pretty=format:"%s"', { encoding: 'utf8' });
    if (!shortLog || shortLog.trim().length === 0) {
      console.log('⚠️  Commit message cannot be empty');
      return false;
    }
  } catch (e) {
    // Ignore if no commits yet
  }

  return true;
}

/**
 * Check for too many files in commit
 */
function checkCommitSize() {
  try {
    const stagedCount = execSync('git diff --cached --name-only | wc -l', { encoding: 'utf8' });
    const count = parseInt(stagedCount.trim(), 10);

    if (count > 50) {
      console.log(`⚠️  Too many files staged (${count} > 50). Consider splitting.`);
      return false;
    }
  } catch (e) {
    // Ignore errors
  }

  return true;
}

/**
 * Main execution
 */
function main() {
  console.log('🔍 Running pre-commit checks...\n');

  let allPassed = true;

  // Run all checks
  if (!checkSensitiveData()) {
    allPassed = false;
  }

  if (!checkCommitMessage()) {
    allPassed = false;
  }

  if (!checkCommitSize()) {
    allPassed = false;
  }

  console.log('\n✅ Pre-commit checks completed\n');

  process.exit(allPassed ? 0 : 1);
}

// Execute
main();
