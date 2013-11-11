// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.raty
//= require bootstrap
//= require turbolinks
//= require_tree .

//$('.dropdown-toggle').dropdown()

$(document).ready(function(){

  showAndHide($("#tile-1"));
  showAndHide($("#tile-2"));
  showAndHide($("#tile-3"));
  showAndHide($("#tile-4"));
  showAndHide($("#tile-5"));
  showAndHide($("#tile-6"));
  showAndHide($("#tile-7"));
  showAndHide($("#tile-8"));
  showAndHide($("#tile-9"));

  function showAndHide( obj )
  {
    var tile = obj;

    tile.siblings("div.tile-content").css({
      position: "absolute",
      top: tile.position().top + "px",
      left: tile.position().left + "px",
      width: tile.outerWidth() + "px"
    });

    tile.parent().hover(
      function(){
        tile.find("h3").hide();
        tile.find("h4").hide();
        $(this).children("div.tile-content").show();
      },
      function(){
        tile.find("h3").show();
        tile.find("h4").show();
        $(this).children("div.tile-content").hide();
      }
    );
  }

});

function showValue( val ) {
  $( "div.message" ).text( "The value is " + val );
}
