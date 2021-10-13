// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import "trix";
import "@rails/actiontext";

import * as bootstrap from "bootstrap";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import Sortable from "sortablejs";

import "../stylesheets/application";

require("@rails/activestorage").start();
require("trix");
require("@rails/actiontext");

// Bootstrap
document.addEventListener("DOMContentLoaded", function (event) {
  var popoverTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="popover"]')
  );
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl);
  });

  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
});

// Hide / Show rich_text content on article>parts#edit
// Sortbale
document.addEventListener("turbolinks:load", () => {
  document.addEventListener("click", (e) => {
    let element = e.target.closest(".paragraph-content");
    if (!element) return;

    element.classList.add("d-none");
    element.nextElementSibling.classList.remove("d-none");
  });

  document.addEventListener("click", (e) => {
    if (!e.target.matches(".cancel")) return;

    let element = e.target.closest(".paragraph-form");

    element.classList.add("d-none");
    element.peviousElementSibling.classList.remove("d-none");
  });

  let element = document.getElementById("elements");
  new Sortable(elements, { animation: 150 });
});

import "controllers";
