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

function writeVariants(o, name, cb) {
  o.state = JSON_stringify(o.state);
  writeFile(distDir + '/' + name + '.json', o.state, function() {
    o.state = JSON_stringify(o.state);
    var css = '#_::after{content:' + o.state + '}';
    writeFile(distDir + '/' + name + '.css', css, function() {
      css = undefined;
      o.state = 'jsonp(' + o.state + ');';
      writeFile(distDir + '/' + name + '.js', o.state, function() {
        o.state = undefined;
        cb();
      });
    });
  });
}

function writePlainText(o, cb) {
  var w = new Object;
  w.state = new Object;
  w.state.now = o.state.now;
  w.state.gitVersion = o.state.gitVersion;
  writeVariants(w, 'status', function() {
    w = undefined;
    writeVariants(o, 'all-txt', cb);
  });
}

function buildLibInit() {
  var cb = function(){};
  readFile(gitDir + '/HEAD', function(head) {
    function gotCommit(ref) {
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
          var o = new Object;
          o.state = state;
          state = undefined;
          writePlainText(o, cb);
        });
    }

    var ref = head.trim();
    ref = ref.split(' ');
    ref = ref[1];
    if (ref) {
      readFile(gitDir + '/' + ref, gotCommit);
    } else {
      gotCommit(head);
    }
  });
}
