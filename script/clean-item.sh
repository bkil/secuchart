#!/bin/sh

main() {
  if [ $# -ne 1 ]; then
    echo "usage: $0 [app_slug]" >&2
    exit 1
  fi
  O="`dirname "$0"`"
  SLUG="$1"
  ITEM="$O/../data/$SLUG.csv"
  if ! [ -f "$ITEM" ]; then
    echo "error: $ITEM does not exist" >&2
    exit 1
  fi

  TMP="$ITEM.tmp"
  if [ -f "$TMP" ]; then
    echo "error: temporary file $TMP already exists" >&2
    exit 1
  fi

  grep -v "^[^;]*;* *$" "$ITEM" > "$TMP"
  mv -v "$TMP" "$ITEM"
}

main "$@"
