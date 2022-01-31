#!/bin/sh
O="`dirname "$0"`"
DATA="$O/../data"

process_slugs() {
  FUN="$1"
  shift 1
  [ -d "$DATA" ] || exit 1

  if [ $# -eq 0 ]; then
    for OUT in "$DATA"/[^_]*.csv; do
      echo $OUT >&2
      $FUN "$OUT" || exit 1
    done
  else
    for SLUG in "$@"; do
      OUT="$DATA/$1.csv"
      echo $OUT >&2
      $FUN "$OUT" || exit 1
    done
  fi
  echo "ok" >&2
}

check_item_syntax() {
  FILE="$1"

  if ! [ -f "$FILE" ]; then
    echo "error: $FILE missing" >&2
    return 1
  fi

  GOODBODY="^[^ ;][^;]*[^ ;];(|yes|no|partial)(;[^;]*){0,2}$"
  if
    tail -n +2 "$FILE" |
    grep -vqE "$GOODBODY"
  then
    echo "error: the following lines are not good in $FILE according to $GOODBODY" >&2

    tail -n +2 "$FILE" |
    grep -vE "$GOODBODY" >&2

    return 1
  fi

  GOODHEAD="^name;;[^ ;][^;]*;?$"
  if
    head -n 1 "$FILE" |
    grep -vqE "$GOODHEAD"
  then
    echo "error: the following lines are not good in $FILE according to $GOODHEAD" >&2

    head -n 1 "$FILE" |
    grep -vE "$GOODHEAD" >&2

    return 1
  fi

  BADBODY="^[^;]+; *;(yes|no|partial)\>"
  if
    head -n 1 "$FILE" |
    grep -qE "$BADBODY"
  then
    echo "error: the following lines are bad in $FILE according to $BADBODY" >&2

    head -n 1 "$FILE" |
    grep -E "$BADBODY" "$FILE" >&2

    return 1
  fi

  MULTIPLE="$(\
  cut -d ";" -f 1 "$FILE" |
  sort |
  uniq -c |
  grep -v "^ *1\>" |
  sed -r "s~^ *[0-9]+ ~~")"
  if [ -n "$MULTIPLE" ]; then
    printf "error: the following keys occur multiple times:\n%s\n" "$MULTIPLE" >&2
    return 1
  fi

  return 0
}

get_property_keys() {
  echo "name"

  cut -d ";" -f 1 "$DATA/_properties.csv" |
  grep -v "^$"
}

extend_reorder() {
  OUT="$1"
  check_item_syntax "$OUT" || exit 1

  TMP="$OUT.tmp"
  get_property_keys |
  while read PROP; do
    grep -E "^$PROP;" "$OUT" || printf "%s;\n" "$PROP"
  done > "$TMP"
  mv "$TMP" "$OUT"
}
