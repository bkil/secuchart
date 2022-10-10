#!/bin/sh

set +u
if [ -z "$_INCLUDED_INCLUDE_INC_SH" ]; then
  _INCLUDED_INCLUDE_INC_SH=1
  . "`dirname "$0"`/include.inc.sh" || exit 1
fi
set -u

main() {
  local LIMITITEMS ITEMS ITEMNAME
  readonly LIMITITEMS="$*"
  readonly ITEMS="$DATA/_items.csv"

  get_items "$LIMITITEMS" |
  while read -r ITEMNAME; do
    enrich_metadata "$ITEMNAME"
  done
}

enrich_metadata() {
  local ITEMPROPS OUT FURL RELEASE ANDROID
  readonly ITEMPROPS="$DATA/$ITEMNAME.csv"
  readonly OUT="$DATA/cache/$ITEMNAME.csv"
  rm "$OUT" 2>/dev/null

  readonly FURL="`find_fdroid_url "$ITEMPROPS"`"
  if [ -n "$FURL" ]; then
    download_fdroid_metadata "$FURL" "$ITEMNAME" |
    {
      read RELEASE ANDROID
      [ -n "$RELEASE" ] && [ -n "$ANDROID" ] &&
        printf "F-droid version;;%s (Android %s+)\n" "$RELEASE" "$ANDROID" >> "$OUT"
    }
  fi
}

find_fdroid_url() {
  grep -Eo -m1 "https://f-droid.org/([^/; ]{2,}/)?packages/.*" "$@" 2>/dev/null |
  grep -o "^[^; ]*"
}

download_fdroid_metadata() {
  local URL HTML
  readonly URL="$1"
  readonly HTML="$DIST/fdroid-$2.html"

  printf "%s\n" "$URL" >&2

  if ! [ -f "$HTML" ]; then
    curl \
      -A "enrich-metadata.sh/0.1 (https://github.com/bkil/secuchart)" \
      "$URL" > "$HTML"
    sleep 1
  fi

  sed -rn "
    s~^\t{5}<b>Version ([^<>]*)</b> \([^)]*\)$~\1~
    T next
    p
    b end
    :next
    s~^\t{5}This version requires Android ([^ ]+) or newer\.$~\1~
    T end
    p
    q
    :end
  " "$HTML" |
  xargs printf "%s %s"
}

main "$@"
