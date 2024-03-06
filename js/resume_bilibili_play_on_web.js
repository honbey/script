// ==UserScript==
// @name         Resume play automatically on Bilibili
// @namespace    http://tampermonkey.net/
// @version      2023-12-10
// @description  try to take over the world!
// @author       Honbey
// @match        *://www.bilibili.com/video/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  // const closeLoginBtn = document.querySelector('body > div.bili-mini-mask > div > div.bili-mini-close-icon');

  // Reference: https://www.163.com/dy/article/GIE0I3F40531H1T5.html
  function getNetworkRequesets(
    entries = performance.getEntriesByType("resource"),
    type = ["xmlhttprequest"],
  ) {
    return entries.filter((entry) => {
      return type.indexOf(entry.initiatorType) > -1;
    });
  }

  function printRequest(requests) {
    if (requests.length !== 0) {
      console.log(requests.map((request) => request.name));
    }
  }

  const triggerRegex =
    /http[s]?:\/\/api\.bilibili\.com\/.*w_real_played_time=(45|60|105|315)/gm;
  //const triggerRegex = /api.bilibili.com/g;

  function resumeVideoPlay(requests) {
    if (requests.length !== 0) {
      requests.map((request) => {
        if (request.name.search(triggerRegex) > -1) {
          const playBtn = document.querySelector(
            "#bilibili-player > div > div > div.bpx-player-primary-area" +
              "> div.bpx-player-video-area > div.bpx-player-control-wrap " +
              "> div.bpx-player-control-entity > div.bpx-player-control-b" +
              "ottom > div.bpx-player-control-bottom-left > div.bpx-playe" +
              "r-ctrl-btn.bpx-player-ctrl-play",
          );
          const player = document.querySelector("#bilibili-player > div > div");
          console.log(player.getAttribute("class"));
          setTimeout(() => {
            if (
              playBtn !== null &&
              player.getAttribute("class").includes("bpx-state-paused")
            ) {
              playBtn.click();
            }
            console.log(
              'Having Detected "' + request.name + '", to resume video play',
            );
          }, 100);
        }
      });
    }
  }

  function perfObserver(list, observer) {
    var requests = getNetworkRequesets(list.getEntriesByType("resource"));
    // printRequest(requests);
    resumeVideoPlay(requests);
  }

  const reqObserver = new PerformanceObserver(perfObserver);
  reqObserver.observe({ entryTypes: ["resource"] });
})();
