define(['jquery'], function ($) {
  function wrapper(text, cssClass) {
    return (
      '<span class="' + cssClass + '">' +
      text +
      '</span>'
    );
  }
  function timeString(date) {
    function pad(s) {
      return ((''+s).length < 2 ? '0' : '') + s;
    }
    return (
      wrapper(pad(date.getHours()), 'time-hour') +
      wrapper(':', 'time-colon') +
      wrapper(pad(date.getMinutes()), 'time-minute')
    );
  }

  function updateClock() {
    var dt = new Date();
    $('.widget-time').html(
      dt.toLocaleDateString() + " " + timeString(dt)
    );
  }

  $(document).ready(function () {
    updateClock();
    setInterval(updateClock, 1000);
  });
});
