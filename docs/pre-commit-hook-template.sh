#!/bin/bash
# ========================================
# Pre-Commit Hook (Shell Script)
# Copy to .git/hooks/pre-commit or use with husky
# ========================================

# Check if files are staged
files=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || echo "")

if [ -z "$files" ]; then
    exit 0
fi

echo "🔍 Running pre-commit checks on:"
echo "$files"
echo ""

# Check for sensitive information (customize patterns for your project)
for file in $files; do
    if grep -qiE "(password|secret|token|key)\s*[:=]\s*[\'\"\w]{8,}" "$file" 2>/dev/null; then
        echo "❌ WARNING: Potential sensitive data detected in: $file"
        # Uncomment below to fail the commit
        # exit 1
    fi
done

# Check for TODO/FIXME comments (optional)
for file in $files; do
    if grep -qE "(TODO|FIXME|XXX)" "$file" 2>/dev/null; then
        echo "⚠️  WARNING: TODO/FIXME comment in: $file"
        # Uncomment below to fail the commit
        # exit 1
    fi
done

# Check binary file size (> 5MB should use LFS)
for file in $files; do
    if [ -f "$file" ]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        if [ "$size" -gt 5242880 ] 2>/dev/null; then  # 5MB in bytes
            echo "⚠️  WARNING: Binary file exceeds 5MB (consider Git LFS): $file"
            # Uncomment below to fail the commit
            # exit 1
        fi
    fi
done

# Count staged files (warn if > 50)
count=$(echo "$files" | wc -l)
if [ "$count" -gt 50 ]; then
    echo "⚠️  WARNING: Too many files staged ($count). Consider splitting into multiple commits."
    # Uncomment below to fail the commit
    # exit 1
fi

echo ""
echo "✅ All pre-commit checks passed!"
