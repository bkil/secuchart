#!/bin/sh

main() {
  O="`dirname $0`"
  DIST="$O/../dist"
  WEB="$O/../web"
  DATA="$O/../data"
  ITEMS="$DATA/_items.csv"

  mkdir -p "$DIST" || exit 1
  cp -at "$DIST" "$O/../LICENSE" || exit 1
  gen_index > "$DIST/index.html" || exit 1
}

gen_index() {
  IN="$WEB/index.template.html"

  sed "s~^~_~" "$IN" |
  while read REPL; do
    REPLY="`echo "$REPL" | sed "s~^_~~"`"
    if [ "$REPLY" = "((style))" ]; then
      gen_style
    elif [ "$REPLY" = "((filters))" ]; then
      gen_filters
    elif [ "$REPLY" = "((table))" ]; then
      gen_table
    else
      printf "%s\n" "$REPLY"
    fi
  done
}

gen_style() {
  echo "<style>"
  cat "$ITEMS" |
  {
    PROPR=""
    NUM=2
    while read IT; do
      NAME=`get_item_value "$IT" "name"`
      printf "#%s:checked ~ table tr > *:nth-child(%d),\n" "$IT" "$NUM"

      SERVERLIC=`get_item_value "$IT" "Server license"`
      CLIENTLIC=`get_item_value "$IT" "Client license"`
      echo "$SERVERLIC $CLIENTLIC" | grep -q "proprietary" && PROPR="$PROPR $NUM"

      NUM=`expr $NUM + 1`
    done

    for NUM in $PROPR; do
      printf "#proprietary:checked ~ table tr > *:nth-child(%d),\n" "$NUM"
    done
  }

  cat <<EOF
#IGNORETHIS
{
  display: none;
}
</style>
EOF
}

gen_filters() {
  echo "<span>Hide messengers:</span>"

  cat "$ITEMS" |
  while read IT; do
    NAME=`get_prop_value "$(get_item_prop "$IT" "name")"`
    printf "<label for=%s>%s&nbsp;</label><input type=checkbox id=%s>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<label for=proprietary>proprietary&nbsp;</label><input type=checkbox id=proprietary>
EOF
}

gen_table() {
  printf "<tr>\n <th>Feature\n"

  print_items "name" 1

  NUMITEMS="`wc -l < "$ITEMS"`"
  COLSPAN=""
  for I in `seq 1 $NUMITEMS`; do
    COLSPAN="$COLSPAN<td>"
  done
  COLSPAN="$COLSPAN</td>"

  cat "$DATA/_properties.csv" |
  while read P; do
    echo "<tr>"
    K="`echo "$P" | cut -d';' -f 1`"
    V="`echo "$P" | cut -d';' -s -f 2-`"
    if [ -z "$K" ]; then
      printf " <th class=section>%s%s\n\n" "$V" "$COLSPAN"
    elif [ -n "$V" ]; then
      printf " <th><details><summary>%s</summary>%s</details>\n" "$K" "$V"
      print_items "$K" 0
    else
      printf " <th>%s\n" "$K"
      print_items "$K" 0
    fi
  done
}

get_item_prop() {
  ITEMNAME="$1"
  FINDKEY="$2"

  DE="$DATA/$ITEMNAME.csv"
  [ -f "$DE" ] || { echo "error: missing $DE" >&2; exit 1; }
  grep -m1 "^${FINDKEY};" "$DE" |
  cut -d';' -s -f 2-
  VALUE="`echo "$PROP" | cut -d';' -f 1 | sed -r "s~(&[a-zA-Z]+),~\1;~g"`"
}

get_prop_status() {
  echo "$1" |
  cut -d';' -s -f 1 |
  escape
}

linkify() {
  sed -r "s~\<((http|ftp)s?://[^ ]*)~<a href='\1'>w</a>~g"
}

escape() {
  sed "
    s~&~\&amp;~g
    s~<~\&lt;~g
    s~>~\&gt;~g
  "
}

get_prop_value() {
  STATUS="`get_prop_status "$1"`"
  SUMMARY="`echo "$1" | cut -d';' -s -f 2 | escape`"
  DETAILS="`echo "$1" | cut -d';' -s -f 3 | escape`"

  if [ -z "$SUMMARY" ]; then
    SUMMARY="$STATUS"
  else
    NOLINK="`echo "$SUMMARY" | sed -r "s~\<((http|ftp)s?://[^ ]*)~~g"`"
    if [ -z "$NOLINK" ]; then
      SUMMARY="$STATUS $SUMMARY"
    fi
  fi

  VALUE="$SUMMARY"
  if [ -n "$DETAILS" ]; then
    VALUE="<details><summary>$VALUE</summary>$DETAILS</details"
  fi

  echo "$VALUE" |
  sed -r "s~(&[a-zA-Z]+),~\1;~g" |
  linkify
}

get_item_value() {
  get_prop_value "`get_item_prop "$@"`"
}

print_items() {
  FINDKEY="$1"
  ISHEAD="$2"

  ADDTAG="td"
  [ "$ISHEAD" = 1 ] && ADDTAG="th"

  cat "$ITEMS" |
  while read IT; do
    PROP="`get_item_prop "$IT" "$FINDKEY"`"

    [ "$ISHEAD" = 1 ] &&  [ -z "$PROP" ] && PROP="$FINDKEY"
    VALUE="`get_prop_value "$PROP"`"

    CLASS=""
    if echo "$FINDKEY" | grep -qE "^(Payment choices|Company jurisdiction|Infrastructure jurisdiction|Infrastructure provider)$"; then
      CLASS="x"
    else
#      FVEY="Australia|Canada|New Zealand|UK|USA"
#      NINEEYES="Denmark|France|Netherlands|Norway"
      if echo "$PROP" | grep -iqE "\<(depends|usually|limited|probably|VC|often|not)\>|\<(venture capital|partial|leak|possibl)|(^|[^0-9a-z_-])only "; then
        CLASS="p"
      fi
      if echo "$PROP" | grep -iqE "\<(no|none|proprietary|unknown|offshore|cryptocoin)\>"; then
        CLASS="n"
      fi
      if echo "$PROP" | grep -iqE "\<yes|N/A\>"; then
        CLASS="y"
      fi
    fi

    STATUS="`get_prop_status "$PROP"`"
    [ -n "$STATUS" ] && CLASS="`echo "$STATUS" | cut -c 1`"
    ATTR=""
    [ -n "$CLASS" ] && ATTR=" class='$CLASS'"
    printf " <%s%s>%s</%s>\n" "$ADDTAG" "$ATTR" "$VALUE" "$ADDTAG"
  done
  echo ""
}

main "$@"
