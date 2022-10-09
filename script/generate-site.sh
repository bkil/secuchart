#!/bin/sh
. "`dirname "$0"`/include.inc.sh"

set -e

main() {
  LIMITITEMS="$*"
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
  while IFS="$TAB" read -r REPLY; do
    if [ "$REPLY" = "((style))" ]; then
      gen_style "$LIMITITEMS"
    elif [ "$REPLY" = "((filters))" ]; then
      gen_filters "$LIMITITEMS"
    elif [ "$REPLY" = "((spans))" ]; then
      gen_spans "$LIMITITEMS"
    elif [ "$REPLY" = "((table))" ]; then
      gen_table "$LIMITITEMS"
    elif [ "$REPLY" = "((script))" ]; then
      cat "$WEB/edit.js"
    elif [ "$REPLY" = "((articles))" ]; then
      gen_articles
    elif [ "$REPLY" = "((static_style))" ]; then
      gen_templated_static_style
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
    TELEGRAM=""
    NUM=2
    while read -r IT; do
      echo "style $IT" >&2
      NAME="`get_item_value "$IT" "name"`"
      cat <<EOF
#$IT:not(:target) ~ #page #any:checked ~ .C:checked ~ #_$IT:not(:checked) ~ table th:nth-child($NUM),
#$IT:not(:target) ~ #page #any:checked ~ .C:checked ~ #_$IT:not(:checked) ~ table td:nth-child($NUM),
#$IT:not(:target) ~ #page #any:checked ~ #_$IT:not(:checked) ~ .C:checked ~ table th:nth-child($NUM),
#$IT:not(:target) ~ #page #any:checked ~ #_$IT:not(:checked) ~ .C:checked ~ table td:nth-child($NUM),
#$IT:not(:target) ~ #page #_$IT:not(:checked) ~ #_nav #a_$IT,
:target ~ #$IT:not(:target) ~ #page table th:nth-child($NUM),
:target ~ #$IT:not(:target) ~ #page table td:nth-child($NUM),
#$IT:not(:target) ~ :target ~ #page table th:nth-child($NUM),
#$IT:not(:target) ~ :target ~ #page table td:nth-child($NUM),
EOF

      SERVERLIC="`get_item_value "$IT" "Server license"`"
      CLIENTLIC="`get_item_value "$IT" "Client license"`"
      printf '%s' "$SERVERLIC $CLIENTLIC" | grep -q "proprietary" && PROPR="$PROPR $NUM"
      PROTOCOL="`get_item_value "$IT" "Protocol"`"
      printf '%s' "$PROTOCOL" | grep -qi "\<Matrix\>" || MATRIX="$MATRIX $NUM"
      printf '%s' "$PROTOCOL" | grep -qi "\<XMPP\>" || XMPP="$XMPP $NUM"
      printf '%s' "$PROTOCOL" | grep -qi "\<MTProto\>" || TELEGRAM="$TELEGRAM $NUM"

      NUM="`expr $NUM + 1`"
    done

    for NUM in $PROPR; do
      printf "#proprietary:checked ~ table th:nth-child(%d),\n" "$NUM"
      printf "#proprietary:checked ~ table td:nth-child(%d),\n" "$NUM"
    done
    for NUM in $MATRIX; do
      printf "#t_matrix:checked ~ table th:nth-child(%d),\n" "$NUM"
      printf "#t_matrix:checked ~ table td:nth-child(%d),\n" "$NUM"
    done
    for NUM in $XMPP; do
      printf "#t_xmpp:checked ~ table th:nth-child(%d),\n" "$NUM"
      printf "#t_xmpp:checked ~ table td:nth-child(%d),\n" "$NUM"
    done
    for NUM in $TELEGRAM; do
      printf "#t_telegram:checked ~ table th:nth-child(%d),\n" "$NUM"
      printf "#t_telegram:checked ~ table td:nth-child(%d),\n" "$NUM"
    done
  }

  get_doc_names |
  while read -r BASE IT; do
    printf "#%s:not(:target) ~ #page > #v_%s,\n" "$BASE" "$BASE"
  done

  cat <<EOF
#DONTCARE
{
  display: none;
}
</style>
EOF
}

gen_templated_static_style() {
  TAB="`printf "\t"`"
  cat "$WEB/static.css" |
  while IFS="$TAB" read -r REPLY; do
    case $REPLY in
      *TEMPLATE_PERSONA*)
        get_all_persona |
        while read -r P; do
          printf "%s\n" "$REPLY" |
          sed "s~TEMPLATE_PERSONA~$P~g"
        done
        ;;
      *)
        printf "%s\n" "$REPLY"
    esac
  done |
  sed ":l; s~\\\\$~~ ; T e; N; s~\n~~; t l; :e"
}

get_doc_names() {
  ls -1 "$DATA/_doc"/*.md |
  sed -r "s~^.*/([0-9-]*)([^/0-9-][^/]*)\.md~\2 \1\2~"
}

gen_spans() {
  LIMITITEMS="$1"

  {
    echo "documentation"
    get_doc_names
  } |
  while read -r BASE IT; do
    echo "<span id=$BASE class=c_documentation></span>"
  done

  get_items "$LIMITITEMS" |
  while read -r IT; do
    echo "<span id=$IT></span>"
  done

  echo
}

gen_filters() {
  LIMITITEMS="$1"
  TMP="$DIST/tmp.html"

  gen_filters_core "$LIMITITEMS" > "$TMP"

  echo "<style>"

  sed -rn "
    s~.*<input type=([^ ]+)\>.*\<id=([^ >]+)[ >].*~\1 \2~
    T e
    p
    :e
  " "$TMP" |
  while read -r TYPE ID; do
    if [ "$TYPE" = "radio" ]; then
    cat << EOF
[for="$ID"]::before { content: "(.) " }
#$ID:checked ~ #_nav [for="$ID"]::before { content: "(o) " }
EOF
    else
    cat << EOF
[for="$ID"]::before { content: "[_] " }
#$ID:checked ~ #_nav [for="$ID"]::before { content: "[x] " }
EOF
    fi
  done

  echo "</style>"

  cat "$TMP"
  rm "$TMP"
}

gen_filters_core() {
  LIMITITEMS="$1"

  cat <<EOF
<input type=checkbox id=_expand>
<input type=checkbox id=transpose>
<input type=radio name=d id=bright checked>
<input type=radio name=d id=dark>
<input type=radio name=d id=contrast>
<input type=checkbox id=abbr>
<input type=checkbox id=allprop checked autofocus>
<input type=radio id=_font_default name=f checked>
<input type=radio id=_font-system-ui name=f>
<input type=radio id=_font-sans name=f>
<input type=radio id=_font-cursive name=f>
<input type=radio id=_font-mono name=f>
<input type=radio id=editor name=u checked>
EOF

  get_all_persona |
  while read -r P; do
    printf "<input type=radio id=%s name=u>\n" "$P"
  done

  cat << EOF
<input type=radio id=any name=S checked class=F>
<input type=radio id=proprietary name=S class="F T">
<input type=radio id=t_matrix name=S class="F T">
<input type=radio id=t_xmpp name=S class="F T">
<input type=radio id=t_telegram name=S class="F T">
EOF

  get_items "$LIMITITEMS" |
  while read -r IT; do
    printf "<input type=checkbox id=_%s class=C>\n" "$IT"
  done

  DATE="`date "+%Y-%m-%d"`"

  cat << EOF
<div id=_nav>
  <div id=_top>
<label for=_expand>Menu</label>
<a href=# class='js-state-view button' id=c_chart>Comparison chart</a>
<a href=#documentation class='js-state-view button' id=c_documentation>Documentation</a>
<span class='js-state-view date'>$DATE</span>

<span class=js-needed>
  <span class='js-start-edit js-state-view button'>Edit chart</span>
  <span class='js-save-review js-state-edit button'>Review edits</span>
  <span class='js-save-review js-state-edit save-warn'><em>Not</em> saved automatically!</span>
  <span class='js-save-back js-state-save-review button'>Resume editing</span>
  <span class='js-save-undo js-state-save-review button'>View chart</span>
</span>
  </div>

  <div id=_filters>
  <label for=transpose>transpose table</label>
  <label for=bright>bright mode</label>
  <label for=dark>dark mode</label>
  <label for=contrast>high contrast</label>
  <label for=abbr>abbreviated</label>
  <label for=allprop>all properties</label>
  <a href="#" id=all class=il>Show all messengers</a>

  <span class=group>Font:</span>
  <label for=_font_default>default</label>
  <label for=_font-system-ui>system-ui</label>
  <label for=_font-sans>sans-serif</label>
  <label for=_font-cursive>cursive</label>
  <label for=_font-mono>monospace</label>

  <span class=group>Use case <a class='js-state-view il' href=#persona>[?]</a>:</span>
  <label for=editor>editor</label>
EOF

  get_all_persona |
  while read -r P; do
    printf "<label for=%s>%s</label>\n" "$P" "$P"
  done

  cat <<EOF
  <span class='F group'>Items:</span>
  <label for=any class=F>any&nbsp;</label>
  <label for=proprietary class=F>non-proprietary</label>
  <label for=t_matrix class=F>matrix</label>
  <label for=t_xmpp class=F>xmpp</label>
  <label for=t_telegram class=F>telegram</label>
  <span class='C group'>Compare messengers:</span>
EOF

  get_items "$LIMITITEMS" |
  while read -r IT; do
    NAME="`get_prop_value "$(get_item_prop "$IT" "name")"`"
    printf "<label for=_%s class=C>%s</label>\n" "$IT" "$NAME"
  done

  cat <<EOF
  <br class=P>
EOF

  get_items "$LIMITITEMS" |
  while read -r IT; do
    printf "<a href=#%s class='P il' id=a_%s>Permalink #%s</a>\n" "$IT" "$IT" "$IT"
  done

  cat << EOF
  </div>
</div>
EOF
}

gen_articles() {
  cat <<EOF
<div class=documentation id=v_documentation>
<ul>
EOF

  get_doc_names |
  while read -r BASE IT; do
    local CHART="$DATA/`echo "$IT" | sed "s/_review$//"`.csv"
    [ -f "$CHART" ] && continue
    local DOC="$DATA/_doc/$IT.md"
    local TITLE="`grep -o -m1 "[^# ].*" "$DOC"`"
    printf "<li><a href=#%s class=il>%s</a>\n" "$BASE" "$TITLE"
  done

  cat << EOF
</ul>
</div>
EOF

  get_doc_names |
  while read -r BASE IT; do
    echo ""
    printf "<div class=documentation id=v_%s>\n" "$BASE"
    markdown2html "$DATA/_doc/$IT.md"
    echo "</div>"
  done
}

# this is mostly compatible with gemini
markdown2html() {
  local IN="$1"
  sed -nr "
    :loop
    s~^\`\`\`~<pre>~
    T no_pre
    N
    s~\n\`\`\`$~</pre>~
    t p
    s~\n~~
    t pre
    :pre
    N
    s~\n\`\`\`$~</pre>~
    T pre
    b p

    :no_pre
    s~^=> *([^ ]*)$~<p><a href='\1' class=bl>\1</a></p>~
    t p
    s~^=> *([^ ]*) (.*)~<p><a href='\1' class=bl>\2</a></p>~
    t p
    s~^### *([^ ].*)~<h3>\1</h3>~
    t p
    s~^## *([^ ].*)~<h2>\1</h2>~
    t p
    s~^# *([^ ].*)~<h1>\1</h1>~
    t p

    s~\<(((https?|ftps?|file)://|(mailto|tel):)[^ ]*)~<a href='\1' target=_blank rel=noopener class=bl>\1</a>~g
    t linked
    s~(^| )(#[a-zA-Z0-9_-]+)~\1<a href='\2' class=il>\2</a>~g
    t linked

    :linked
    s~^> *([^ ].*)~<blockquote>\1</blockquote>~
    t p

    s~^[*] *([^ ].*)~<ul>\n<li>\1</li>~
    T no_list
    :list
    p
    n

    s~\<(((https?|ftps?|file)://|(mailto|tel):)[^ ]*)~<a href='\1' target=_blank rel=noopener class=bl>\1</a>~g
    t linked_list
    s~(^| )(#[a-zA-Z0-9_-]+)~\1<a href='\2' class=il>\2</a>~g
    t linked_list
    :linked_list

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

  printf "<tr class=tr-th>\n <th class=th-pr>Feature\n"

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
    while IFS=";" read -r K V PERSONA; do
      if [ -z "$K" ]; then
        printf "<tr class=section>\n <th class=th-sect>%s%s\n\n" "$V" "$COLSPAN"
      else
        EDIT=""
        [ "$K" = "Analysis" ] && EDIT=" js-no-edit"
        if [ -n "$PERSONA" ]; then
          echo "<tr class='$PERSONA$EDIT'>"
        else
          echo "<tr>"
        fi

        if [ -n "$V" ]; then
          echo "property $K" >&2
          printf " <th class=th-pr><details class=prop-det><summary class=prop-sum>%s</summary>%s</details>\n" "$K" "$V"
          print_items "$K" 0
        else
          echo "property $K" >&2
          printf " <th class=th-pr>%s\n" "$K"
          print_items "$K" 0
        fi
      fi
    done
  }
}

get_item_prop() {
  ITEMNAME="$1"
  FINDKEY="$2"

  if [ "$FINDKEY" = "Analysis" ]; then
    DE="$DATA/_doc/${ITEMNAME}_review.md"
    [ -f "$DE" ] || return
    printf ";#%s_review\n" "$ITEMNAME"
  else
    DE="$DATA/$ITEMNAME.csv"
    [ -f "$DE" ] || { echo "error: missing $DE" >&2; exit 1; }
    grep -m1 "^${FINDKEY};" "$DE" |
    cut -d';' -s -f 2-
  fi
}

get_prop_status() {
  printf '%s' "$1" |
  cut -d';' -f 1 |
  escape
}

linkify() {
  sed -r "
    s~(^| )(#[^ ]*)~\1<a href=\2 class=a>\2</a>~g
    s~\<((http|ftp)s?://[^ ]*)~<a href='\1' target=_blank rel=noopener class=a>w</a>~g
    "
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
  while read -r IT; do
    PROP="`get_item_prop "$IT" "$FINDKEY"`"

    [ "$ISHEAD" = 1 ] &&  [ -z "$PROP" ] && PROP="$FINDKEY"
    VALUE="`get_prop_value "$PROP"`"

    if [ "$ISHEAD" = 1 ]; then
      ATTR=" class=th-it"
    else
      CLASS="`get_entry_status_class "$FINDKEY" "$PROP"`"
      ATTR=""
      [ -n "$CLASS" ] && ATTR=" class='$CLASS'"
    fi

    printf " <%s%s>%s</%s>\n" "$ADDTAG" "$ATTR" "$VALUE" "$ADDTAG"
  done
  echo ""
}

main "$@"
