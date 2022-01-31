#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

main() {
  process_slugs check_item_syntax "$@"
}

main "$@"
