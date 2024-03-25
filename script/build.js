'use strict';

// Copyright (C) 2024 bkil.hu
// Report any incompatibility with either nodeJS or gemiweb0/js0.

var fs = require('fs');

function readFile(name, cb) {
  fs.readFile(name, function(e, d) {
    if (e) {
      console.log(e + ' ' + name)
    } else {
      d = d + '';
      setTimeout(function() { cb(d); }, 0);
    }
  });
}

readFile('lib.js', function(src) {
  var libJs = new Object;
  libJs.s = src;
  src = undefined;
  setTimeout(function() {
    readFile('build-lib.js', function(src) {
      src = libJs.s + src + 'buildLibInit();';
      libJs = undefined;
      setTimeout(function() {
        eval(src);
      }, 0);
    });
  }, 0);
});
