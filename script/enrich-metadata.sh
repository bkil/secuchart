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
  local ITEMPROPS OUT FURL GURL DATE RELEASE ANDROID SIZE
  readonly ITEMPROPS="$DATA/$ITEMNAME.csv"
  readonly OUT="$DATA/cache/$ITEMNAME.csv"
  rm "$OUT" 2>/dev/null

  readonly FURL="`find_fdroid_url "$ITEMPROPS"`"
  if [ -n "$FURL" ]; then
    download_fdroid_metadata "$FURL" "$ITEMNAME" |
    {
      read DATE RELEASE ANDROID SIZE
      [ -n "$DATE" ] && [ -n "$RELEASE" ] && [ -n "$ANDROID" ] && [ -n "$SIZE" ] &&
        printf "F-droid version;;%s: %s %s (Android %s+)\n" "$DATE" "$RELEASE" "$SIZE" "$ANDROID" >> "$OUT"
    }
  fi

  readonly GURL="`find_google_play_url "$ITEMPROPS"`"
  if [ -n "$GURL" ]; then
    download_google_play_metadata "$GURL" "$ITEMNAME" |
    {
      read DATE RELEASE ANDROID SIZE
      [ -n "$DATE" ] && [ -n "$RELEASE" ] && [ -n "$ANDROID" ] && [ -n "$SIZE" ] &&
        printf "Google Play version;;%s: %s %s (Android %s+)\n" "$DATE" "$RELEASE" "$SIZE" "$ANDROID" >> "$OUT"
    }
  fi
}

find_fdroid_url() {
  grep -Eo -m1 "https://f-droid.org/([^/; ]{2,}/)?(packages|app)/.*" "$@" 2>/dev/null |
  grep -o "^[^; ]*"
}

find_google_play_url() {
  grep -Eo -m1 "https://play.google.com/store/apps/details.*" "$@" 2>/dev/null |
  grep -o "^[^;& ]*"
}

download_fdroid_metadata() {
  local URL HTML DATE RELEASE OS SIZE
  readonly URL="$1"
  readonly HTML="$DIST/fdroid-$2.html"

  printf "%s\n" "$URL" >&2

  curl2 "$HTML" "$URL"

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

    s~^\t{5}Added on ([^<>]+)$~\1~
    T not_date
    s~^Jan~01~
    s~^Feb~02~
    s~^Mar~03~
    s~^Apr~04~
    s~^May~05~
    s~^Jun~06~
    s~^Jul~07~
    s~^Aug~08~
    s~^Sep~09~
    s~^Oct~10~
    s~^Nov~11~
    s~^Dec~12~
    s~^([0-9]+) ([0-9]+), ([0-9]+)$~\3-\1-\2~
    s~-([0-9])$~-0\1~
    p
    b continue
    :not_date

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
  {
    read RELEASE
    read DATE
    read OS
    read SIZE
    printf "%s %s %s %s" "$DATE" "$RELEASE" "$OS" "$SIZE"
  }
}

download_google_play_metadata() {
  local OGURL HTML URL
  readonly OGURL="$1"
  readonly HTML="$DIST/google-play-$2.html"
  readonly URL="`printf "%s" "$OGURL" | sed "s~^https://play\.google\.com/store/apps/details[?]id=~https://apkpure.com/0/~"`"

  printf "%s\n" "$URL" >&2

  curl2 "$HTML" "$URL"

  sed "s~\r~~g" "$HTML" |
  sed -rn "
    s~^<p itemprop=\"datePublished\">([^<>]+)</p>$~date\t\1~
    t print

    s~^<p class=\"date\">([A-Z][a-z]{2} [0-9]{1,2}, [0-9]{4})</p>~date\t\1~
    t date_update
    s~^<span class=\"update\">([A-Z][a-z]{2} [0-9]{1,2}, [0-9]{4})</span>~update\t\1~
    T not_date_update
    :date_update
    s~\tJan~\t01~
    s~\tFeb~\t02~
    s~\tMar~\t03~
    s~\tApr~\t04~
    s~\tMay~\t05~
    s~\tJun~\t06~
    s~\tJul~\t07~
    s~\tAug~\t08~
    s~\tSep~\t09~
    s~\tOct~\t10~
    s~\tNov~\t11~
    s~\tDec~\t12~
    s~\t([0-9]+) ([0-9]+), ([0-9]+)$~\t\3-\1-\2~
    s~-([0-9])$~-0\1~
    b print
    :not_date_update

    s~^<div class=\"details-sdk\"><span itemprop=\"version\">([^<>]*[^<> ]) *</span>for Android</div>$~rel\t\1~
    t print
    s~^<div class=\"ver-info-top\"><strong>.*</strong> ([^ <>()]+)( *\([0-9]+\))?</div>.*$~rel\t\1~
    t print
    s~^<a class=\"version-item .* data-dt-version=\"([^<>\"]+)\".*$~rel\t\1~
    t print
    s~^<span itemprop=\"version\">([^<>]+)</span> by$~rel\t\1~
    t print
    s~<h3>What&#39;s New in the Latest Version ([^<>]+)</h3>~rel\t\1~
    t print

    s~^<p>(Android )?([0-9]+\.[0-9]+)( and up|[+])?</p>$~os\t\2~
    t print
    s~^<p><strong>Requires Android: </strong>Android ([^()<>]*[^()<>+ ])([+]| and up)?( *\([^<>]*\))?</p>$~os\t\1~
    t print
    s~^<p class=\"additional-info\">(Android )?([0-9.]+)([+]| and up)?</p>$~os\t\2~
    t print

    s~^<p><strong>File Size: </strong>([^<>]+) (MB)</p>$~size\t\1\2~
    t print
    s~^<span class=\"(size|ver-item-s)\">([^<>]+) (MB)</span>$~size\t\2\3~
    t print

    b continue
    :print
    s~ ~_~g
    p
    :continue
  " |

  awk -F "\t" '
    BEGIN {
      date = "?";
      update = "?";
      rel = "?";
      size = "?";
      os = "?";
    }
    {
      if ((date == "?") && ($1 == "date")) {
        date = $2;
      } else if ((update == "?") && ($1 == "update")) {
        update = $2;
      } else if ((rel == "?") && ($1 == "rel")) {
        rel = $2;
      } else if ((size == "?") && ($1 == "size")) {
        size = $2;
      } else if ((os == "?") && ($1 == "os")) {
        os = $2;
      }
    }
    END {
      if (update != "?") {
        date = update;
      }
      if ((date != "?") || (rel != "?") || (size != "?") || (os != "?")) {
        printf("%s %s %s %s\n", date, rel, os, size);
      }
    }
  '
}

curl2() {
  local CURLFILE
  readonly CURLFILE="$1"
  shift 1

  if ! [ -f "$CURLFILE" ]; then
    curl \
      -A "enrich-metadata.sh/0.1 (https://github.com/bkil/secuchart)" \
      --location \
      "$@" > "$CURLFILE"
    sleep 1
  fi
}

main "$@"
