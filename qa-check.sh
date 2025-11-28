#!/bin/bash
# QA Check Script - Verifies no secrets or personal data in repository

echo "🔍 Running QA Check on free-chatbot-api..."
echo "=========================================="

ERRORS=0

# Check for hardcoded secrets
echo ""
echo "Checking for hardcoded secrets..."
if grep -r "gsk_[A-Za-z0-9]" --include="*.py" --include="*.md" --include="*.txt" . 2>/dev/null | grep -v ".git" | grep -v "venv" | grep -v "__pycache__"; then
    echo "❌ Found hardcoded Groq API keys!"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ No hardcoded Groq API keys found"
fi

if grep -r "MTQzOTg2NjExNDcwNzU1ODQ5Mw" --include="*.py" --include="*.md" --include="*.txt" . 2>/dev/null | grep -v ".git" | grep -v "venv" | grep -v "__pycache__"; then
    echo "❌ Found hardcoded Discord bot tokens!"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ No hardcoded Discord bot tokens found"
fi

# Check for personal data
echo ""
echo "Checking for personal data..."
if grep -ri "Song Hui\|Hassan\|Trump\|Corey\|Great Oak" --include="*.py" --include="*.md" . 2>/dev/null | grep -v ".git" | grep -v "venv" | grep -v "__pycache__" | grep -v "personality.example.py" | grep -v "README.md" | grep -v "PROJECT_STATUS.md"; then
    echo "❌ Found personal data references!"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ No personal data references found (excluding examples)"
fi

# Check for hardcoded channel IDs
echo ""
echo "Checking for hardcoded channel IDs..."
if grep -r "1440947548364734599\|1309981184746586175" --include="*.py" . 2>/dev/null | grep -v ".git" | grep -v "venv" | grep -v "__pycache__"; then
    echo "❌ Found hardcoded channel IDs!"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ No hardcoded channel IDs found"
fi

# Check .env.example exists
echo ""
echo "Checking configuration files..."
if [ -f ".env.example" ]; then
    echo "✅ .env.example exists"
else
    echo "❌ .env.example missing!"
    ERRORS=$((ERRORS + 1))
fi

# Check personality.example.py exists
if [ -f "personality.example.py" ]; then
    echo "✅ personality.example.py exists"
else
    echo "❌ personality.example.py missing!"
    ERRORS=$((ERRORS + 1))
fi

# Summary
echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ QA Check PASSED - No issues found"
    exit 0
else
    echo "❌ QA Check FAILED - Found $ERRORS issue(s)"
    exit 1
fi
