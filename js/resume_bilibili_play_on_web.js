// ==UserScript==
// @name         Resume play automatically on Bilibili
// @namespace    http://tampermonkey.net/
// @version      2025-01-25
// @description  try to take over the world!
// @author       Honbey
// @match        *://www.bilibili.com/video/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  // https://www.52pojie.cn/thread-1827587-1-1.html
  let oldXhrOpen = XMLHttpRequest.prototype.open;
  XMLHttpRequest.prototype.open = function () {
    if (arguments[1].indexOf("/web-interface/nav") != -1) {
      let oldGet = Object.getOwnPropertyDescriptor(
        XMLHttpRequest.prototype,
        "responseText",
      ).get;
      Object.defineProperty(this, "responseText", {
        configurable: true,
        enumerable: true,
        get: function get() {
          let res = JSON.parse(oldGet.apply(this, arguments));
          res.code = 0;
          res.message = "0";
          res.data = {
            isLogin: true,
            wbi_img: [],
          };
          return JSON.stringify(res);
        },
        set: undefined,
      });
    }
    return oldXhrOpen.apply(this, arguments);
  };

  let oldJsonParse = JSON.parse;
  JSON.parse = function () {
    if (arguments[0].indexOf('"isLogin":false') != -1) {
      arguments[0] = arguments[0]
        .replace('"code":-101', '"code":0')
        .replace('"isLogin":false', '"isLogin":true');
    }
    return oldJsonParse.apply(this, arguments);
  };

  let oldfetch = fetch;
  function fuckfetch() {
    if (arguments[0].indexOf("/web-interface/nav") != -1) {
      debugger;
      return new Promise((resolve, reject) => {
        oldfetch.apply(this, arguments).then((response) => {
          const oldJson = response.json;
          response.json = function () {
            return new Promise((resolve, reject) => {
              oldJson.apply(this, arguments).then((result) => {
                //修改result
                resolve(result);
              });
            });
          };
          resolve(response);
        });
      });
    } else {
      return oldfetch.apply(this, arguments);
    }
  }
  window.fetch = fuckfetch;
})();
