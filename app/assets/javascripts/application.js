// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-slider
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function () {

  var output = document.getElementById("out");

  if (!navigator.geolocation){
    output.innerHTML = "<p>Geolocation is not supported by your browser</p>";
    return;
  }

  function success(position) {
    var now = new Date();
    var time = now.getTime();
    var expireTime = time + 1000*600;
    now.setTime(expireTime);
    var latitude  = position.coords.latitude;
    var longitude = position.coords.longitude;
    document.cookie = "latitude=" + latitude + ";expires="+now.toGMTString()+';path=/';
    document.cookie = "longitude=" + longitude + ";expires="+now.toGMTString()+';path=/';
    console.log('done');
  }

  function error() {
    output.innerHTML = "Unable to retrieve your location";
  }

  output.innerHTML = "<p>Locating…</p>";

  navigator.geolocation.getCurrentPosition(success, error);
});
