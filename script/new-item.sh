#!/bin/sh

main() {
  echo "Create a new empty item based on _properties.csv" >&2
  if [ $# -ne 1 ]; then
    echo "usage: $0 [item_slug]" >&2
    exit 1
  fi
  O="`dirname "$0"`"
  DATA="$O/../data"
  [ -d "$DATA" ] || exit 1

  SLUG="$1"
  OUT="$DATA/$SLUG.csv"
  if [ -f "$OUT" ]; then
    echo "error: $OUT already exists" >&2
    exit 1
  fi

  {
    echo "name;;$SLUG"

    cut -d';' -f 1 "$DATA/_properties.csv" |
    grep -v "^$" |
    sed "s~$~;~"
  } > "$OUT"

  ITEMS="$DATA/_items.csv"
  if grep -q "^$SLUG$" "$ITEMS"; then
    echo "warning: $SLUG already referenced in $ITEMS" >&2
  else
    echo "$SLUG" >> "$ITEMS"
    echo "created $ITEMS" >&2
  fi
}

main "$@"
