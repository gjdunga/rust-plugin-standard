#!/usr/bin/env bash
#
# resync.sh — copy the standard's vendored files into one or more plugin repos.
#
# The DunganSoft Plugin Standard vendors a handful of files into every plugin
# repo: the conformance checker, the signing script, the listing/icon
# generators, and the public signing key. When any of them change here they must
# be re-synced into each plugin repo (see CLAUDE.md). This script does that
# verbatim and verifies the result.
#
# Usage:
#   tools/resync.sh <plugin-repo> [<plugin-repo> ...]        # sync the files
#   tools/resync.sh --check <plugin-repo> [<plugin-repo> ...]# report drift only, write nothing
#
# Exit status: 0 = everything in sync (or synced); 1 = drift found in --check
# mode (or a bad target); 2 = usage error.
#
# It does NOT touch the per-repo GitHub release workflow — that's templated with
# __PLUGIN__/__TITLE__ (see templates/workflows/), not a verbatim copy, so
# re-render it from the template when it changes. This script also never deletes
# anything and never commits; review and commit in each repo yourself.
set -euo pipefail

STD="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Files vendored verbatim into each plugin repo (paths relative to the repo root).
VENDORED=(
  tools/check-standard.py
  tools/sign-plugin.sh
  tools/make-listing.py
  tools/make-icon.py
  keys/gjdunga.asc
)

usage() {
  echo "usage: tools/resync.sh [--check] <plugin-repo> [<plugin-repo> ...]" >&2
  exit 2
}

CHECK=0
targets=()
for a in "$@"; do
  case "$a" in
    --check)   CHECK=1 ;;
    -h|--help) grep -E '^#( |$)' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)        echo "unknown option: $a" >&2; usage ;;
    *)         targets+=("$a") ;;
  esac
done
[[ ${#targets[@]} -eq 0 ]] && usage

drift=0
synced=0
for repo in "${targets[@]}"; do
  if [[ ! -d "$repo/.git" ]]; then
    echo "!! $repo: not a git repository — skipping" >&2
    drift=1; continue
  fi
  echo "== $(basename "$repo") =="
  for rel in "${VENDORED[@]}"; do
    src="$STD/$rel"; dst="$repo/$rel"
    if [[ ! -f "$src" ]]; then
      echo "  ?? no source for $rel in the standard — skipped" >&2
      continue
    fi
    if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
      echo "  ok    $rel"
      continue
    fi
    if [[ $CHECK -eq 1 ]]; then
      [[ -f "$dst" ]] && echo "  DRIFT $rel" || echo "  MISS  $rel"
      drift=1
    else
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
      [[ "$rel" == *.sh ]] && chmod +x "$dst"
      echo "  sync  $rel"
      synced=1
    fi
  done
done

if [[ $CHECK -eq 1 ]]; then
  [[ $drift -ne 0 ]] && { echo "drift found — run without --check to sync." >&2; exit 1; }
  echo "all targets in sync."
else
  [[ $synced -eq 0 ]] && echo "nothing to do — all targets already in sync." || echo "done — review and commit in each repo."
  [[ $drift -ne 0 ]] && exit 1
fi
exit 0
