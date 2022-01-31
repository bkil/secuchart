#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

main() {
  echo "Removing properties with an empty value from the item" >&2
  process_slugs process "$@"
}

process() {
  OUT="$1"
  extend_reorder "$OUT"

  TMP="$OUT.tmp"
  grep -vE "^[^;]*(; *)*$" "$OUT" > "$TMP"
  mv "$TMP" "$OUT"
}

main "$@"
