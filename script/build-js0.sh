#!/bin/sh
cd "$(dirname "$(readlink -f "$0")")" || exit 1

! [ -f js0-min-static ] || ! [ -f lib.js ] && {
  wget -U- \
    https://bkil.gitlab.io/gemiweb/js0-min-static \
    https://bkil.gitlab.io/gemiweb/src/br/lib.js &&
  chmod +x ./js0-min-static || exit 1
}

mkdir -p ../dist/0 || exit 1
./js0-min-static build.js
