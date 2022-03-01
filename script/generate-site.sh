#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

set -e

main() {
  LIMITITEMS="$*"
  DIST="$O/../dist"
  WEB="$O/../web"
  ITEMS="$DATA/_items.csv"

  mkdir -p "$DIST" || exit 1
  cp -a "$O/../LICENSE" "$DIST/LICENSE" || exit 1
  cp -a "$O/../data/LICENSE" "$DIST/LICENSE.data" || exit 1
  gen_index "$LIMITITEMS" > "$DIST/index.html" || exit 1
}

gen_index() {
  LIMITITEMS="$1"
  IN="$WEB/index.template.html"

  TAB="`printf "\t"`"
  cat "$IN" |
  while IFS="$TAB" read REPLY; do
    if [ "$REPLY" = "((style))" ]; then
      gen_style "$LIMITITEMS"
    elif [ "$REPLY" = "((filters))" ]; then
      gen_filters "$LIMITITEMS"
    elif [ "$REPLY" = "((spans))" ]; then
      gen_spans "$LIMITITEMS"
    elif [ "$REPLY" = "((table))" ]; then
      gen_table "$LIMITITEMS"
    elif [ "$REPLY" = "((date))" ]; then
      DATE="`date "+%Y-%m-%d"`"
      printf "<span class='js-state-view date'>%s</span>" "$DATE"
    elif [ "$REPLY" = "((script))" ]; then
      cat "$WEB/edit.js"
    elif [ "$REPLY" = "((articles))" ]; then
      gen_articles
    elif [ "$REPLY" = "((static_style))" ]; then
      cat "$WEB/static.css"
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
    MATRIX=""
    XMPP=""
    NUM=2
    while read IT; do
      echo "style $IT" >&2
      NAME="`get_item_value "$IT" "name"`"
      cat <<EOF
#$IT:not(:target) ~ #page > #v_chart > #any:checked ~ .C:checked ~ #_$IT:not(:checked) ~ table tr > *:nth-child($NUM),
#$IT:not(:target) ~ #page > #v_chart > #any:checked ~ #_$IT:not(:checked) ~ .C:checked ~ table tr > *:nth-child($NUM),
#$IT:not(:target) ~ #page > #v_chart > #_$IT:not(:checked) ~ #a_$IT,
:target ~ #$IT:not(:target) ~ #page > #v_chart > table tr > *:nth-child($NUM),
#$IT:not(:target) ~ :target ~ #page > #v_chart > table tr > *:nth-child($NUM),
EOF

      SERVERLIC="`get_item_value "$IT" "Server license"`"
      CLIENTLIC="`get_item_value "$IT" "Client license"`"
      printf '%s' "$SERVERLIC $CLIENTLIC" | grep -q "proprietary" && PROPR="$PROPR $NUM"
      PROTOCOL="`get_item_value "$IT" "Protocol"`"
      printf '%s' "$PROTOCOL" | grep -qi "\<matrix\>" || MATRIX="$MATRIX $NUM"
      printf '%s' "$PROTOCOL" | grep -qi "\<xmpp\>" || XMPP="$XMPP $NUM"

      NUM="`expr $NUM + 1`"
    done

    for NUM in $PROPR; do
      printf "#proprietary:checked ~ table tr > *:nth-child(%d),\n" "$NUM"
    done
    for NUM in $MATRIX; do
      printf "#t_matrix:checked ~ table tr > *:nth-child(%d),\n" "$NUM"
    done
    for NUM in $XMPP; do
      printf "#t_xmpp:checked ~ table tr > *:nth-child(%d),\n" "$NUM"
    done
  }

  get_doc_names |
  while read IT; do
    printf "#%s:not(:target) ~ #page > #v_%s,\n" "$IT" "$IT"
  done

  cat <<EOF
#DONTCARE
{
  display: none;
}
</style>
EOF
}

get_doc_names() {
  ls -1 "$DATA/_doc"/*.md |
  sed "s~\.md$~~ ; s~^.*/~~"
}

gen_spans() {
  LIMITITEMS="$1"

  {
    echo "documentation"
    get_doc_names
  } |
  while read IT; do
    echo "<span id=$IT class=c_documentation></span>"
  done

  get_items "$LIMITITEMS" |
  while read IT; do
    echo "<span id=$IT></span>"
  done

  echo
}

gen_filters() {
  LIMITITEMS="$1"

  cat <<EOF
<label for=abbr>abbreviated&nbsp;</label><input type=checkbox id=abbr>
<label for=allprop>all properties&nbsp;</label><input type=checkbox id=allprop checked autofocus>
<a href="#" id=all>Show all messengers</a>
<br>
Use case:
<label for=editor>editor&nbsp;</label><input type=radio id=editor name=u checked>
<label for=foss>FOSS&nbsp;</label><input type=radio id=foss name=u>
<label for=tinfoil>tinfoil&nbsp;</label><input type=radio id=tinfoil name=u>
<label for=layperson>layperson&nbsp;</label><input type=radio id=layperson name=u>
<br class=F>
<span class=F>Items:</span>
<label for=any class=F>any&nbsp;</label><input type=radio id=any name=S checked class=F>
<label for=proprietary class=F>non-proprietary&nbsp;</label><input type=radio id=proprietary name=S class="F T">
<label for=t_matrix class=F>matrix&nbsp;</label><input type=radio id=t_matrix name=S class="F T">
<label for=t_xmpp class=F>xmpp&nbsp;</label><input type=radio id=t_xmpp name=S class="F T">
<br class=C>
<span class=C>Compare messengers:</span>
EOF

  get_items "$LIMITITEMS" |
  while read IT; do
    echo "filter $IT" >&2
    NAME="`get_prop_value "$(get_item_prop "$IT" "name")"`"
    printf "<label for=_%s class=C>%s&nbsp;</label><input type=checkbox id=_%s class=C>\n" "$IT" "$NAME" "$IT"
  done

  cat <<EOF
<br class=P>
EOF

  get_items "$LIMITITEMS" |
  while read IT; do
    printf "<a href=#%s class=P id=a_%s>Permalink #%s</a>\n" "$IT" "$IT" "$IT"
  done
}

gen_articles() {
  cat <<EOF
<div class=documentation id=v_documentation>
<ul>
EOF

  get_doc_names |
  while read IT; do
    local DOC="$DATA/_doc/$IT.md"
    local TITLE="`grep -o -m1 "[^# ].*" "$DOC"`"
    printf "<li><a href=#%s>%s</a>\n" "$IT" "$TITLE"
  done

  cat << EOF
</ul>
</div>
EOF

  get_doc_names |
  while read IT; do
    echo ""
    printf "<div class=documentation id=v_%s>\n" "$IT"
    markdown2html "$DATA/_doc/$IT.md"
    echo "</div>"
  done
}

# this is mostly compatible with gemini
markdown2html() {
  local IN="$1"
  sed -nr "
    :loop
    s~^### *([^ ].*)~<h3>\1</h3>~
    t p
    s~^## *([^ ].*)~<h2>\1</h2>~
    t p
    s~^# *([^ ].*)~<h1>\1</h1>~
    t p
    s~^> *([^ ].*)~<blockquote>\1</blockquote>~
    t p
    s~^=> *([^ ]*)$~<p><a href='\1'>\1</a></p>~
    t p
    s~^=> *([^ ]*) (.*)~<p><a href='\1'>\2</a></p>~
    t p
    s~^([*] *)?(((https?|ftps?|file)://|(mailto|tel):)[^ ]*)~<p><a href='\2'>\2</a></p>~
    t p
    s~^([*] *)?(((https?|ftps?|file)://|(mailto|tel):)[^ ]*) (.*)~<p><a href='\2'>\6</a></p>~
    t p

    s~^[*] *([^ ].*)~<ul>\n<li>\1</li>~
    T no_list
    :list
    p
    n
    s~(^)[*] *([^ ].*)~\1<li>\2</li>~
    t list
    h
    s~.*~</ul>~
    p
    g
    t loop

    :no_list
    s~.+~<p>&</p>~
    T e
    :p
    p
    :e
  " "$IN"
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
  {
    sed -r "
      s~^(([^;]*;){2})([^; ])~\1require-\3~
      s~^(([^;]*;){3})([^; ])~\1benefit-\3~
      s~^(([^;]*;){4})([^; ])~\1info-\3~

      t space_to_comma
      :space_to_comma
      s~^(([^;]*;){2}[^ ]*) +~\1,~
      t space_to_comma

      :a
      s~^(([^;]*;){2}[^;,]*),+([^;,])~\1 require-\3~
      t a
      :b
      s~^(([^;]*;){3}[^;,]*),+([^;,])~\1 benefit-\3~
      t b
      :c
      s~^(([^;]*;){4}[^;,]*),+([^;,])~\1 info-\3~
      t c
      s~^(([^;]*;){2});+~\1~

      t semi_to_space
      :semi_to_space
      s~^(([^;]*;){2}[^;]*);+([^;])~\1 \3~
      t semi_to_space
      s~;+$~~
    " |
    while IFS=";" read K V PERSONA; do
      if [ -z "$K" ]; then
        printf "<tr class=section>\n <th>%s%s\n\n" "$V" "$COLSPAN"
      else
        if [ -n "$PERSONA" ]; then
          echo "<tr class='$PERSONA'>"
        else
          echo "<tr>"
        fi

        if [ -n "$V" ]; then
          echo "property $K" >&2
          printf " <th><details><summary>%s</summary>%s</details>\n" "$K" "$V"
          print_items "$K" 0
        else
          echo "property $K" >&2
          printf " <th>%s\n" "$K"
          print_items "$K" 0
        fi
      fi
    done
  }
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
  cut -d';' -f 1 |
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

  if is_colorless_property "$FINDKEY"; then
    return
  fi

  CLASS=""
  if false; then
    FVEY="Australia|Canada|New Zealand|UK|USA"
    NINEEYES="Denmark|France|Netherlands|Norway"
    if printf '%s' "$PROP" | grep -iqE "\<(depends|usually|limited|probably|VC|often|not)\>|\<(venture capital|partial|leak|possibl)|(^|[^0-9a-z_-])only "; then
      CLASS="p"
    fi
    if printf '%s' "$PROP" | grep -iqE "\<(no|none|proprietary|unknown|offshore|cryptocoin)\>"; then
      CLASS="n"
    fi
    if printf '%s' "$PROP" | grep -iqE "\<yes|N/A\>"; then
      CLASS="y"
    fi
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
