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
      cat <<EOF
#$IT:not(:target) ~ #any:checked ~ #_$IT:not(:checked) ~ table tr > *:nth-child($NUM),
#$IT:not(:target) ~ #any:not(:checked) ~ #s_$IT:not(:checked) ~ table tr > *:nth-child($NUM),
#$IT:not(:target) ~ #any:not(:checked) ~ #s_$IT:not(:checked) ~ #a_$IT,
#$IT:not(:target) ~ #any:checked ~ #a_$IT,
:target ~ #$IT:not(:target) ~ table tr > *:nth-child($NUM),
#$IT:not(:target) ~ :target ~ table tr > *:nth-child($NUM),
EOF

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
#any:not(:checked) ~ .C,
#any:checked ~ .P,
:target ~ .C,
:target ~ .S,
#all
{
  display: none;
}

:target ~ #all,
:target ~ #all ~ .P
{
  display: initial;
}
</style>
EOF
}

gen_filters() {
  cat "$ITEMS" |
  while read IT; do
    echo "<span id=$IT></span>"
  done
  echo

  cat <<EOF
<a href="#" id=all>Show all messengers</a>
<br>
<span class=S>Single messenger:</span>
<label for=any class=S>any&nbsp;</label><input type=radio name=S checked autofocus accesskey=a id=any class=S>
EOF

  cat "$ITEMS" |
  while read IT; do
    NAME=`get_prop_value "$(get_item_prop "$IT" "name")"`
    printf "<label for=s_%s class=S>%s&nbsp;</label><input type=radio name=S id=s_%s class=S>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<br class=P>
EOF

  cat "$ITEMS" |
  while read IT; do
    printf "<a href=#%s id=a_%s>Permalink #%s</a>\n" "$IT" "$IT" "$IT"
  done

  cat <<EOF
<br class=C>
<span class=C>Compare messengers:</span>
EOF

  cat "$ITEMS" |
  while read IT; do
    NAME=`get_prop_value "$(get_item_prop "$IT" "name")"`
    printf "<label for=_%s class=C>%s&nbsp;</label><input type=checkbox checked id=_%s class=C>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<label for=proprietary class=C>non-proprietary&nbsp;</label><input type=checkbox id=proprietary class=C>
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
  SUMMARYU="`echo "$1" | cut -d';' -s -f 2 | escape`"
  SUMMARY="`echo "$SUMMARYU" | linkify`"
  DETAILS="`echo "$1" | cut -d';' -s -f 3 | escape | linkify`"

  if [ -z "$SUMMARY" ]; then
    SUMMARY="$STATUS"
  else
    NOLINK="`echo "$SUMMARYU" | sed -r "s~\<((http|ftp)s?://[^ ]*)~~g ; s~^ *~~ ; s~ *$~~"`"
    if [ -z "$NOLINK" ]; then
      SUMMARY="$STATUS $SUMMARY"
    fi
  fi

  VALUE="$SUMMARY"
  if [ -n "$DETAILS" ]; then
    VALUE="<details><summary>$VALUE</summary>$DETAILS</details"
  fi

  echo "$VALUE"
}

get_item_value() {
  get_prop_value "`get_item_prop "$@"`"
}

get_entry_status_class() {
  FINDKEY="$1"
  PROP="$2"

  if [ "$FINDKEY" = "name" ]; then
    return
  fi

  CLASS=""
  if echo "$FINDKEY" | grep -qE "^(Summary|Payment choices|Company jurisdiction|Infrastructure jurisdiction|Infrastructure provider|Servers required|Servers optional|Protocol)$"; then
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
  echo "$CLASS"
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

    CLASS="`get_entry_status_class "$FINDKEY" "$PROP"`"
    ATTR=""
    [ -n "$CLASS" ] && ATTR=" class='$CLASS'"
    printf " <%s%s>%s</%s>\n" "$ADDTAG" "$ATTR" "$VALUE" "$ADDTAG"
  done
  echo ""
}

main "$@"
