#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

main() {
  echo "Extend item with additional possible properties" >&2
  process_slugs extend_reorder "$@"
}

main "$@"
