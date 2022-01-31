#!/bin/sh

set -e

main() {
  LIMITITEMS="$*"
  O="`dirname $0`"
  DIST="$O/../dist"
  WEB="$O/../web"
  DATA="$O/../data"
  ITEMS="$DATA/_items.csv"

  mkdir -p "$DIST" || exit 1
  cp -at "$DIST" "$O/../LICENSE" || exit 1
  gen_index "$LIMITITEMS" > "$DIST/index.html" || exit 1
}

gen_index() {
  LIMITITEMS="$1"
  IN="$WEB/index.template.html"

  sed "s~^~_~" "$IN" |
  while read REPL; do
    REPLY="`printf '%s' "$REPL" | sed "s~^_~~"`"
    if [ "$REPLY" = "((style))" ]; then
      gen_style "$LIMITITEMS"
    elif [ "$REPLY" = "((filters))" ]; then
      gen_filters "$LIMITITEMS"
    elif [ "$REPLY" = "((table))" ]; then
      gen_table "$LIMITITEMS"
    else
      printf "%s\n" "$REPLY"
    fi
  done
}

gen_style() {
  LIMITITEMS="$1"

  echo "<style>"
  get_items "$LIMITITEMS" |
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
      printf '%s' "$SERVERLIC $CLIENTLIC" | grep -q "proprietary" && PROPR="$PROPR $NUM"

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
  LIMITITEMS="$1"

  get_items "$LIMITITEMS" |
  while read IT; do
    echo "<span id=$IT></span>"
  done
  echo

  cat <<EOF
<a href="#" id=all>Show all messengers</a>
<br>
<span class=S>Single messenger:</span>
<label for=any class=S>any&nbsp;</label><input type=radio name=S checked accesskey=a id=any class=S>
EOF

  get_items "$LIMITITEMS" |
  while read IT; do
    NAME=`get_prop_value "$(get_item_prop "$IT" "name")"`
    printf "<label for=s_%s class=S>%s&nbsp;</label><input type=radio name=S id=s_%s class=S>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<br class=P>
EOF

  get_items "$LIMITITEMS" |
  while read IT; do
    printf "<a href=#%s id=a_%s>Permalink #%s</a>\n" "$IT" "$IT" "$IT"
  done

  cat <<EOF
<br class=C>
<span class=C>Compare messengers:</span>
EOF

  get_items "$LIMITITEMS" |
  while read IT; do
    NAME=`get_prop_value "$(get_item_prop "$IT" "name")"`
    printf "<label for=_%s class=C>%s&nbsp;</label><input type=checkbox checked id=_%s class=C>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<label for=proprietary class=C>non-proprietary&nbsp;</label><input type=checkbox id=proprietary class=C>
EOF
}

gen_table() {
  LIMITITEMS="$1"

  printf "<tr>\n <th>Feature\n"

  print_items "name" 1

  NUMITEMS="`get_items "$LIMITITEMS" | wc -l`"
  COLSPAN=""
  for I in `seq 1 $NUMITEMS`; do
    COLSPAN="$COLSPAN<td>"
  done
  COLSPAN="$COLSPAN</td>"

  cat "$DATA/_properties.csv" |
  while read P; do
    echo "<tr>"
    K="`printf '%s' "$P" | cut -d';' -f 1`"
    V="`printf '%s' "$P" | cut -d';' -s -f 2-`"
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
  VALUE="`printf '%s' "$PROP" | cut -d';' -f 1 | sed -r "s~(&[a-zA-Z]+),~\1;~g"`"
}

get_prop_status() {
  printf '%s' "$1" |
  cut -d';' -s -f 1 |
  escape
}

linkify() {
  sed -r "s~\<((http|ftp)s?://[^ ]*)~<a href='\1' target=_blank>w</a>~g"
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
  SUMMARYU="`printf '%s' "$1" | cut -d';' -s -f 2 | escape`"
  SUMMARY="`printf '%s' "$SUMMARYU" | linkify`"
  DETAILS="`printf '%s' "$1" | cut -d';' -s -f 3 | escape | linkify`"

  if [ -z "$SUMMARY" ]; then
    SUMMARY="$STATUS"
  else
    NOLINK="`printf '%s' "$SUMMARYU" | sed -r "s~\<((http|ftp)s?://[^ ]*)~~g ; s~^ *~~ ; s~ *$~~"`"
    if [ -z "$NOLINK" ]; then
      SUMMARY="$STATUS $SUMMARY"
    fi
  fi

  VALUE="$SUMMARY"
  if [ -n "$DETAILS" ]; then
    VALUE="<details><summary>$VALUE</summary>$DETAILS</details"
  fi

  printf '%s' "$VALUE"
}

get_item_value() {
  get_prop_value "`get_item_prop "$@"`"
}

get_entry_status_class() {
  FINDKEY="$1"
  PROP="$2"

  if printf '%s' "$FINDKEY" | grep -qE "^(name|Summary|Payment choices|Company jurisdiction|Infrastructure jurisdiction|Infrastructure provider|Servers required|Servers optional|Protocol|Read public content without registering|Company operated network inaccessible from countries)$"; then
    echo "x"
    return
  fi

  CLASS=""
#      FVEY="Australia|Canada|New Zealand|UK|USA"
#      NINEEYES="Denmark|France|Netherlands|Norway"
    if printf '%s' "$PROP" | grep -iqE "\<(depends|usually|limited|probably|VC|often|not)\>|\<(venture capital|partial|leak|possibl)|(^|[^0-9a-z_-])only "; then
      CLASS="p"
    fi
    if printf '%s' "$PROP" | grep -iqE "\<(no|none|proprietary|unknown|offshore|cryptocoin)\>"; then
      CLASS="n"
    fi
    if printf '%s' "$PROP" | grep -iqE "\<yes|N/A\>"; then
      CLASS="y"
    fi

  STATUS="`get_prop_status "$PROP"`"
  [ -n "$STATUS" ] && CLASS="`printf '%s' "$STATUS" | cut -c 1`"
  printf '%s' "$CLASS"
}

print_items() {
  FINDKEY="$1"
  ISHEAD="$2"

  ADDTAG="td"
  [ "$ISHEAD" = 1 ] && ADDTAG="th"

  get_items "$LIMITITEMS" |
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

get_items() {
  LIMITITEMS="$1"
  if [ -n "$LIMITITEMS" ]; then
    echo "$LIMITITEMS" |
    sed -r "s~ +~\n~g"
  else
    cat "$ITEMS"
  fi
}

main "$@"
