// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import rrulePlugin from '@fullcalendar/rrule';
import clipboard from 'clipboard';

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');

  let eventsCache = undefined;
  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin, rrulePlugin ],
    events: (info, success, fallback) => {
      if (eventsCache) {
        success(eventsCache);
      } else {
        fetch('/calendar.json').then((resp) => resp.json()).then((data) => {
          eventsCache = data;
          success(data);
        });
      }
    },
    color: 'cyan',
    textColor: 'white',
    header: {
      left: 'dayGridMonth,dayGridWeek',
      center: 'title',
      right: 'today prev,next'
    }
  });

  calendar.render();

  const copyButton = document.getElementById('ical_copy');

  new clipboard(copyButton);
});
