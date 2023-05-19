#!/bin/sh
O="`dirname "$0"`"
DATA="$O/../data"
DIST="$O/../dist"

process_slugs() {
  FUN="$1"
  shift 1
  [ -d "$DATA" ] || exit 1

  if [ $# -eq 0 ]; then
    ls "$DATA" |
    grep "^[^_].*\.csv$" |
    while read OUT; do
      echo $DATA/$OUT >&2
      $FUN "$DATA/$OUT" || exit 1
    done
  else
    for SLUG in "$@"; do
      OUT="$DATA/$SLUG.csv"
      echo $OUT >&2
      $FUN "$OUT" || exit 1
    done
  fi
  echo "ok" >&2
}

get_temp() {
  TMPNAME="`tempfile -p "secu-" -s ".secuchart.tmp" 2>/dev/null`"
  [ -n "$TMPNAME" ] || TMPNAME="secu-`date +%s.%N`.$$.`hostname 2>/dev/null`.secuchart.tmp"
  echo "$TMPNAME"
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
    tail -n +2 "$FILE" |
    grep -qE "$BADBODY"
  then
    echo "error: the following lines are bad in $FILE according to $BADBODY" >&2

    tail -n +2 "$FILE" |
    grep -E "$BADBODY" "$FILE" >&2

    return 1
  fi

  LINES="$(\
    cut -d ";" -f 1 "$FILE" |
    sort |
    uniq -c |
    grep -v "^ *1\>" |
    sed -r "s~^ *[0-9]+ ~~")"
  if [ -n "$LINES" ]; then
    printf "error: the following keys occur multiple times:\n%s\n" "$LINES" >&2
    return 1
  fi

  TMP="`get_temp`"
  get_property_keys > "$TMP"
  LINES="`grep -vFf "$TMP" "$FILE"`"
  if [ -n "$LINES" ]; then
    rm "$TMP"
    printf "error: the following lines use unknown property keys:\n%s\n" "$LINES" >&2
    return 1
  fi
  rm "$TMP"

  LINES="`\
    grep_colorless_property "$FILE" |
    grep_color_optional -v |
    grep "^[^;]*;[^;]"`"
  if [ -n "$LINES" ]; then
    printf "error: the following lines should not specify a status:\n%s\n" "$LINES" >&2
    return 1
  fi

  LINES="`\
    grep_colorless_property -v "$FILE" |
    grep -E "^[^;]*;;(;?[^;]+)"`"
  if [ -n "$LINES" ]; then
    printf "error: a status is expected in the following lines:\n%s\n" "$LINES" >&2
    return 1
  fi

  LINES="`LC_ALL=c grep "[^ -~]" "$FILE"`"
  if [ -n "$LINES" ]; then
    printf "error: non-ASCII characters detected:\n%s\n" "$LINES" >&2
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
  grep -v "^Analysis$" |
  while read PROP; do
    grep -E "^$PROP;" "$OUT" || printf "%s;;;\n" "$PROP"
  done |
  sed -r "
    s~  +~ ~g
    s~ *; *~;~g
    s~ *$~~

    t start
    :start
    s~^[^;]*;[^;]*$~&;;~
    t end
    s~^[^;]*(;[^;]*){2}$~&;~
    :end
  " > "$TMP"
  mv "$TMP" "$OUT"
}

grep_color_optional() {
  grep -E "^(Read public content without registering|Vendor operated network inaccessible from countries)(;|$)" "$@"
}

grep_colorless_property() {
  grep -E "^(name|Summary|Screenshots|Payment choices|Vendor jurisdiction|Infrastructure jurisdiction|Infrastructure provider|Servers required|Servers optional|Protocol|Read public content without registering|Vendor operated network inaccessible from countries|Vendor legal entity kind)(;|$)" "$@"
}

is_colorless_property() {
  printf '%s' "$FINDKEY" |
  grep_colorless_property > /dev/null
}

get_all_persona() {
  cat "$DATA/_persona.csv"
}

get_items() {
  if [ -n "$1" ]; then
    echo "$1" |
    sed -r "s~ +~\n~g"
  else
    cat "$ITEMS"
  fi
}
