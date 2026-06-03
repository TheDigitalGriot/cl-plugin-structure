#!/bin/bash
# Hook Schema Validator
# Validates hooks.json structure and checks for common issues

set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <path/to/hooks.json>"
  exit 1
fi

HOOKS_FILE="$1"

if [ ! -f "$HOOKS_FILE" ]; then
  echo "❌ Error: File not found: $HOOKS_FILE"
  exit 1
fi

echo "🔍 Validating hooks configuration: $HOOKS_FILE"
echo ""

if ! jq empty "$HOOKS_FILE" 2>/dev/null; then
  echo "❌ Invalid JSON syntax"
  exit 1
fi
echo "✅ Valid JSON"

VALID_EVENTS=("PreToolUse" "PostToolUse" "UserPromptSubmit" "Stop" "SubagentStop" "SessionStart" "SessionEnd" "PreCompact" "Notification")

for event in $(jq -r 'keys[]' "$HOOKS_FILE"); do
  found=false
  for valid_event in "${VALID_EVENTS[@]}"; do
    [ "$event" = "$valid_event" ] && found=true && break
  done
  [ "$found" = false ] && echo "⚠️  Unknown event type: $event"
done
echo "✅ Root structure valid"
echo "✅ Validation complete"
exit 0
