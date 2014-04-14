require.config({
  paths: {
    "jquery": "../bower_components/jquery/dist/jquery.min",
    "moment": "../bower_components/moment/min/moment-with-langs.min",
    "tianbar": "tianbar:///data/scripts"
  }
})
require(
  [
    'jquery',
    'tianbar/time',
    'tianbar/xmonad'
  ],
  function ($, time, xmonad) {
    $(document).ready(function () {
      $('html').css('height', $(document).height())
    })
  }
)
