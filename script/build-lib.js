'use strict';

// Copyright (C) 2024 bkil.hu
// Report any incompatibility with either nodeJS or gemiweb0/js0.

var rootDir = '..';
var dataDir = rootDir + '/data';
var distDir = rootDir + '/dist/0';
var gitDir = rootDir + '/.git';
var nl = String.fromCharCode(10);

function writeFile(name, data, cb) {
  fs.writeFile(name, data, function(e) {
    if (e) {
      console.log(e + ' ' + name)
    } else {
      setTimeout(function() { cb(); }, 0);
    }
  });
}

function iterList0(y, list, fun, i, cb) {
  if (i < list.length) {
    fun(list[i], function() {
      y(y, list, fun, i + 1, cb);
    });
  } else {
    cb();
  }
}

function iterList(list, fun, cb) {
  iterList0(iterList0, list, fun, 0, cb);
}

function iterateRec0(y, path, fun, cb) {
  fs.readdir(path, function(e, l) {
    if (e) {
      fun(path, cb);
    } else {
      iterList(l,
        function(v, cb2) {
          y(y, path + '/' + v, fun, cb2);
        },
        cb);
    }
  });
}

function iterateRec(path, fun, cb) {
  iterateRec0(iterateRec0, path, fun, cb);
}

function writePlainText(state, cb) {
  state = JSON_stringify(state);
  writeFile(distDir + '/all-txt.json', state, function() {
    state = JSON_stringify(state);
    var css = '#_:after{content:' + state + '}';
    writeFile(distDir + '/all-txt.css', css, function() {
      css = undefined;
      state = 'jsonp(' + state + ');';
      writeFile(distDir + '/all-txt.js', state, cb);
    });
  });
}

function buildLibInit() {
  var cb = function(){};
  readFile(gitDir + '/HEAD', function(head) {
    console.log(head);
    head = head.split(' ');
    head = head[1];
    readFile(gitDir + '/' + head.trim(), function(ref) {
      var state = new Object;
      state.now = new Date / 1000;
      state.txt = new Object;
      state.gitVersion = ref.trim();
      iterateRec(dataDir,
        function(path, cb2) {
          readFile(path, function(d) {
            state.txt[path.substr(dataDir.length + 1, path.length)] = d;
            d = undefined;
            cb2();
          });
        },

        function() {
          writePlainText(state, cb);
        });
    });
  });
}
