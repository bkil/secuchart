#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

main() {
  PROPS="$O/../data/_properties.csv"

  NAME="([^;]+)"
  DESC="([^;]*)"
  TAG="(all|foss|tinfoil|layperson)"
  TAGS="($TAG( $TAG)*)"
  TAGCOL="(;$TAGS?)"
  NUMTAGCOLS=3
  TAGCOLS="($TAGCOL{0,$NUMTAGCOLS})"
  PROPERTY="($NAME(;$DESC$TAGCOLS)?)"
  HEADER=";$NAME;{0,$NUMTAGCOLS}"
  REGEXP="^($PROPERTY|$HEADER)$"

  LINES="`grep -vE "$REGEXP" "$PROPS"`"
  if [ -n "$LINES" ]; then
    printf "error: the following lines are not good in %s according to %s:\n%s" "$PROPS" "$REGEXP" "$LINES" >&2
    return 1
  fi
  echo "ok" >&2
}

main "$@"
