#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
README="$REPO_ROOT/README.md"
ERRORS=0

# Detect the GitHub base URL from the git remote
REMOTE_URL=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || echo "")
BRANCH=$(git -C "$REPO_ROOT" branch --show-current 2>/dev/null || echo "main")

if [[ "$REMOTE_URL" =~ github\.com[:/](.+)\.git$ ]]; then
  GITHUB_REPO="${BASH_REMATCH[1]}"
  BASE_URL="https://github.com/${GITHUB_REPO}/blob/${BRANCH}"
elif [[ "$REMOTE_URL" =~ github\.com[:/](.+)$ ]]; then
  GITHUB_REPO="${BASH_REMATCH[1]}"
  BASE_URL="https://github.com/${GITHUB_REPO}/blob/${BRANCH}"
else
  BASE_URL=""
fi

echo "=== Checking README link integrity ==="
echo ""

# --- Check 1: Every .md link in README.md points to a real file ---
echo ">> Check 1: All links in README.md resolve to existing files"

# Extract relative .md link targets from Markdown links: [text](path.md)
links=$(grep -oE '\[.*?\]\(\.?/?[^)]+\.md\)' "$README" | sed -E 's/.*\(\.?\/?([^)]+)\)/\1/')

for link in $links; do
  target="$REPO_ROOT/$link"
  if [ ! -f "$target" ]; then
    echo "  FAIL: link target not found: $link"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK:   $link"
  fi
done

echo ""

# --- Check 2: Every NNN-*.md post file is linked in README.md ---
echo ">> Check 2: All post files are linked in README.md"

for post in "$REPO_ROOT"/[0-9][0-9][0-9]-*.md; do
  [ -f "$post" ] || continue
  filename="$(basename "$post")"
  if ! grep -q "$filename" "$README"; then
    echo "  FAIL: post not linked in README.md: $filename"
    ERRORS=$((ERRORS + 1))
  else
    echo "  OK:   $filename"
  fi
done

echo ""

# --- Check 3: Every .md link is reachable via HTTP (live URL check) ---
if [ -n "$BASE_URL" ]; then
  echo ">> Check 3: All links return HTTP 200 at $BASE_URL"

  for link in $links; do
    url="${BASE_URL}/${link}"
    status=$(curl -o /dev/null -s -w "%{http_code}" -L "$url")
    if [ "$status" -ne 200 ]; then
      echo "  FAIL: HTTP $status for $url"
      ERRORS=$((ERRORS + 1))
    else
      echo "  OK:   $url"
    fi
  done
else
  echo ">> Check 3: SKIPPED (no GitHub remote detected — cannot verify live URLs)"
fi

echo ""

# --- Summary ---
if [ "$ERRORS" -gt 0 ]; then
  echo "FAILED: $ERRORS error(s) found."
  exit 1
else
  echo "PASSED: All links valid, all posts linked."
  exit 0
fi
