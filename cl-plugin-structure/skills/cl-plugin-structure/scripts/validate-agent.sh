#!/bin/bash
# Agent File Validator
# Validates agent markdown files for correct structure and content

set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path/to/agent.md>"
  exit 1
fi

AGENT_FILE="$1"

echo "🔍 Validating agent file: $AGENT_FILE"
echo ""

if [ ! -f "$AGENT_FILE" ]; then
  echo "❌ File not found: $AGENT_FILE"
  exit 1
fi
echo "✅ File exists"

FIRST_LINE=$(head -1 "$AGENT_FILE")
if [ "$FIRST_LINE" != "---" ]; then
  echo "❌ File must start with YAML frontmatter (---)"
  exit 1
fi
echo "✅ Starts with frontmatter"

if ! tail -n +2 "$AGENT_FILE" | grep -q '^---$'; then
  echo "❌ Frontmatter not closed (missing second ---)"
  exit 1
fi
echo "✅ Frontmatter properly closed"

FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$AGENT_FILE")
SYSTEM_PROMPT=$(awk '/^---$/{i++; next} i>=2' "$AGENT_FILE")

error_count=0
warning_count=0

NAME=$(echo "$FRONTMATTER" | grep '^name:' | sed 's/name: *//' | sed 's/^"\(.*\)"$/\1/')
if [ -z "$NAME" ]; then
  echo "❌ Missing required field: name"
  ((error_count++))
else
  echo "✅ name: $NAME"
fi

DESCRIPTION=$(echo "$FRONTMATTER" | grep '^description:' | sed 's/description: *//')
if [ -z "$DESCRIPTION" ]; then
  echo "❌ Missing required field: description"
  ((error_count++))
else
  echo "✅ description: ${#DESCRIPTION} characters"
fi

MODEL=$(echo "$FRONTMATTER" | grep '^model:' | sed 's/model: *//')
if [ -z "$MODEL" ]; then
  echo "❌ Missing required field: model"
  ((error_count++))
else
  echo "✅ model: $MODEL"
  case "$MODEL" in
    inherit|sonnet|opus|haiku) ;;
    *) echo "⚠️  Unknown model: $MODEL (valid: inherit, sonnet, opus, haiku)"; ((warning_count++));;
  esac
fi

COLOR=$(echo "$FRONTMATTER" | grep '^color:' | sed 's/color: *//')
if [ -z "$COLOR" ]; then
  echo "❌ Missing required field: color"
  ((error_count++))
else
  echo "✅ color: $COLOR"
  case "$COLOR" in
    blue|cyan|green|yellow|magenta|red) ;;
    *) echo "⚠️  Unknown color: $COLOR"; ((warning_count++));;
  esac
fi

if [ -z "$SYSTEM_PROMPT" ]; then
  echo "❌ System prompt is empty"
  ((error_count++))
else
  echo "✅ System prompt: ${#SYSTEM_PROMPT} characters"
fi

echo ""
if [ $error_count -eq 0 ] && [ $warning_count -eq 0 ]; then
  echo "✅ All checks passed!"
  exit 0
elif [ $error_count -eq 0 ]; then
  echo "⚠️  Validation passed with $warning_count warning(s)"
  exit 0
else
  echo "❌ Validation failed with $error_count error(s) and $warning_count warning(s)"
  exit 1
fi
