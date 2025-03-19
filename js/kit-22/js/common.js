'use strict'

document.addEventListener('DOMContentLoaded', () => {
  const navbarBurger = document.querySelectorAll('.navbar-burger');
  navbarBurger.forEach( el => {
    el.addEventListener('click', () => {
      document.querySelectorAll('.navbar-burger')[0].classList.toggle('is-active');
      document.querySelectorAll('.navbar-menu')[0].classList.toggle('is-active');
    });
  });
});

