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
      read RELEASE ANDROID SIZE
      [ -n "$RELEASE" ] && [ -n "$ANDROID" ] && [ -n "$SIZE" ] &&
        printf "F-droid version;;%s %s (Android %s+)\n" "$RELEASE" "$SIZE" "$ANDROID" >> "$OUT"
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
    T not_release
    p
    b continue
    :not_release

    s~^\t{5}This version requires Android ([^ ]+) or newer\.$~\1~
    T not_android
    p
    b continue
    :not_android

    s~^\t{5}([0-9]+(\.[0-9]+)?) (MiB)$~\1\3~
    T not_size
    p
    b continue
    :not_size

    s~^\t{3}</li>$~&~
    T continue
    n
    s~^$~&~
    T continue
    n
    s~^\t{3}$~&~
    T continue
    n
    s~^\t{3}<li class=\"package-version\" >$~&~
    T continue

    :exit
    q
    :continue
  " "$HTML" |
  xargs printf "%s %s %s"
}

main "$@"
