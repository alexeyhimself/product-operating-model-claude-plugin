#!/usr/bin/env bash
# PreToolUse hook: auto-allow read-only tools (Read/Glob/Grep) on the
# wiki bundled inside this plugin, so users aren't prompted for every
# page the coach opens. Anything else falls through to the normal
# permission flow (empty output = no decision).
set -euo pipefail

input=$(cat)

# Plugin root = parent of this script's directory.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Extract the target path: Read uses tool_input.file_path, Glob/Grep use tool_input.path.
extract() {
  sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' <<<"$input" | head -1
}
path="$(extract file_path)"
[ -z "$path" ] && path="$(extract path)"
[ -z "$path" ] && exit 0

case "$path" in
  "$ROOT/wiki"|"$ROOT/wiki/"*)
    printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Read-only access to the LLM Wiki bundled with the product-coach plugin"}}'
    ;;
esac
exit 0
