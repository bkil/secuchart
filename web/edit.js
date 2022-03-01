'use strict';
(function() {
var last_edited_cell = null;

function init() {
  document.getElementsByClassName('js-start-edit')[0].onclick = start_editing_clicked;
  document.getElementsByClassName('js-save-review')[0].onclick = save_review_clicked;
  document.getElementsByClassName('js-save-back')[0].onclick = save_back_clicked;
  document.getElementsByClassName('js-save-undo')[0].onclick = save_undo_clicked;
  var list = document.getElementsByTagName('body')[0].classList;
  list.add('is-js');
  list.add('is-state-view');
}

function start_editing_clicked() {
  document.getElementsByClassName('js-chart')[0].onclick = chart_clicked;
  alter_state('is-state-view', 'is-state-edit');
}

function save_review_clicked() {
  save_last_edited_cell();

  var text = "```\nscript/extend-item.sh && \npatch -p 0 <<EOF &&\n";

  var items = document.querySelectorAll('span.C ~ input.C');

  var rows = document.getElementsByClassName('js-chart')[0].rows;
  for (var i = 0; i < items.length; i++) {
    var firstProperty = true;
    var headingCount = 0;
    for (var j = 1; j < rows.length; j++) {
      if (is_synthetic_row(rows[j])) {
        headingCount++;
        continue
      }
      var cell = rows[j].children[i + 1];
      if (!cell.classList.contains('is-modified')) {
        continue
      }

      if (firstProperty) {
        firstProperty = false;
        var item = items[i].id.substr(1);
        text += "--- data/" + item + ".csv\n";
        text += "+++ data/" + item + ".csv\n";
      }

      var property = cell.parentNode.firstElementChild;
      if (property.firstElementChild) {
        property = property.firstElementChild.firstElementChild;
      }
      property = property.innerText;

      var new_value = cell.getAttribute('data-new')
      var old_value = cell.getAttribute('data-old')
      var csvIndex = j - headingCount + 1;
      text += '@@ -' + csvIndex + ',1 +' + csvIndex + ",1 @@\n";
      text += '-' + property + ';' + old_value + "\n";
      text += '+' + property + ';' + new_value + "\n";
    }
  }

  text += "EOF\nscript/reduce-item.sh\n```";

  var pre = document.getElementsByClassName('js-changes')[0];
  pre.innerText = text;
  alter_state('is-state-edit', 'is-state-save-review');
}

function save_undo_clicked() {
  document.getElementsByClassName('js-chart')[0].onclick = null;
  alter_state('is-state-save-review', 'is-state-view');
}

function save_back_clicked() {
  alter_state('is-state-save-review', 'is-state-edit');
}

function chart_clicked() {
  var cell = event.target;
  var tag = cell.tagName;
  if (tag === 'SUMMARY') {
    cell = cell.parentNode;
    tag = cell.tagName;
  }
  if (tag === 'DETAILS') {
    cell = cell.parentNode;
    tag = cell.tagName;
  }
  if (tag !== 'TD') {
    return
  }

  if (cell === last_edited_cell) {
    return
  }

  save_last_edited_cell();

  if (is_synthetic_row(cell.parentNode)) {
    return
  }

  activate_cell_editor(cell);
}

function is_synthetic_row(tr) {
  return (tr.classList.contains('section')) || (tr.classList.contains('js-no-edit'));
}

function activate_cell_editor(cell) {
  var parsed = parse_cell(cell);
  if (parsed === null) {
    alert("error: Cell parsing failed, please report this bug");
    return
  }

  var text = render_cell_row(parsed);
  if (!cell.hasAttribute('data-old')) {
    cell.setAttribute('data-old', text);
  }

  cell.className = 'is-cell-editor';
  cell.innerHTML = '';

  var empty = (parsed[0] + parsed[1] + parsed[2]) === '';
  var status = document.createElement('div');
  var cl = cell.parentNode.className;
  var optional = (cl.indexOf('benefit-') < 0) && (cl.indexOf('require-') < 0);
  addRadio(status, 'yes', parsed[0] === 'y', 'yes');
  addRadio(status, 'partial', parsed[0] === 'p');
  addRadio(status, 'no', parsed[0] === 'n');
  addRadio(status, 'N/A', parsed[0] === '', 'na');

  cell.appendChild(status);

  var teaser = document.createElement('div');
  var i = document.createElement('input');
  i.className = 'is-teaser';
  i.placeholder = 'few words of teaser';
  i.value = parsed[1];
  teaser.appendChild(i);
  cell.appendChild(teaser);

  var details = document.createElement('div');
  var t = document.createElement('textarea');
  t.className = 'is-details';
  t.placeholder = 'explanation and links';
  t.value = parsed[2];
  details.appendChild(t);
  cell.appendChild(details);

  i.focus();

  last_edited_cell = cell;
}

function addRadio(div, text, checked, cl) {
  if (!cl) {
    cl = text;
  }
  var label = document.createElement('label');
  var i = document.createElement('input');
  i.name = 'is-radio-status';
  i.type = 'radio';
  i.className = 'is-status-' + cl;
  if (checked) {
    i.setAttribute('checked', '');
  }
  label.innerText = text;
  label.appendChild(i);
  div.appendChild(label);
}

function is_cell_status(status) {
  var input = last_edited_cell.getElementsByClassName('is-status-' + status)[0];
  if (!input) {
    return false;
  }

  return input.checked;
}

function save_last_edited_cell() {
  if (last_edited_cell !== null) {
    var status = is_cell_status('yes') ? 'yes' : is_cell_status('partial') ? 'partial' : is_cell_status('no') ? 'no' : '';
    var teaser = last_edited_cell.getElementsByClassName('is-teaser')[0].value;
    var details = last_edited_cell.getElementsByClassName('is-details')[0].value;
    details = details.replace(/ *\n */g, ' ');
    var text = status + ';' + teaser + ';' + details;

    if (text === last_edited_cell.getAttribute('data-old')) {
      last_edited_cell.removeAttribute('data-old');
      last_edited_cell.removeAttribute('data-new');
    } else {
      last_edited_cell.setAttribute('data-new', text);
      last_edited_cell.classList.add('is-modified');
    }
    last_edited_cell.classList.remove('is-cell-editor');
    render_cell_html(last_edited_cell, text);
    last_edited_cell = null;
  }
}

function unlinkify(html) {
  return html.replace(/<a href=['"]([^['"]*)['"] target=['"]?_blank['"]?>[^<]*<\/a>/g, '$1');
}

function linkify(text) {
  return text.replace(/\b((http|ftp)s?:\/\/[^ ]*)/g, "<a href='$1' target=_blank>w</a>");
}

function status_to_word(state) {
  var map =
    {
      '': '',
      'y': 'yes',
      'n': 'no',
      'p': 'partial'
    };
  return map[state];
}

function word_to_status(state) {
  var map =
    {
      '': '',
      'yes': 'y',
      'no': 'n',
      'partial': 'p'
    };
  return map[state];
}

function render_cell_row(parsed) {
  return status_to_word(parsed[0]) + ';' + parsed[1] + ';' + parsed[2];
}

function status_prefix(teaser, status) {
  if (teaser === '') {
    return status;
  }

  var nolinks = teaser.replace(/\b((http|ftp)s?:\/\/[^ ]*)/g, '').replace(/ */, '');
  if (nolinks === '') {
    return status + ' ' + teaser;
  } else {
    return teaser;
  }
}

function render_cell_html(cell, text) {
  var col = /^([^;]*);([^;]*);([^;]*)$/.exec(text);
  if (col === null) {
    return
  }
  var status = col[1];
  if (status) {
    cell.classList.add(word_to_status(status));
  }
  var teaser = linkify(status_prefix(col[2], status));
  var details = linkify(col[3]);

  if (details) {
    cell.innerHTML = '<details><summary>' + teaser + '</summary>' + details + '</details>';
  } else {
    cell.innerHTML = teaser;
  }
}

function parse_cell(cell) {
  var parsed = null;
  var c = cell.classList;
  var status = c.contains('y') ? 'y' : c.contains('n') ? 'n' : c.contains('p') ? 'p' : '';
  var teaser = '';
  var details = '';
  var maybeDetails = /^<details( [^>]*)?><summary>(.*)<\/summary>(.*)( |\n)*<\/details>$/m.exec(cell.innerHTML);
  if (maybeDetails !== null) {
    teaser = maybeDetails[2];
    details = unlinkify(maybeDetails[3]);
  } else {
    teaser = cell.innerHTML;
  }
  teaser = unlinkify(teaser);
  var word_status = status_to_word(status);
  teaser = teaser.replace(RegExp('^' + word_status + ' *'), '');
  parsed = [status, teaser, details];
  return parsed;
}

function alter_state(old, next) {
  var list = document.getElementsByTagName('body')[0].classList;
  list.remove(old);
  list.add(next);
}

init();
})();
