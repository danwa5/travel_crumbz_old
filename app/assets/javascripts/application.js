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
//= require bootstrap
//= require jquery

//= require jquery_ujs
//= require jquery.raty
//= require turbolinks
//= require_tree .

//$('.dropdown-toggle').dropdown()

$(document).ready(function() {
  $('[data-toggle=offcanvas]').click(function() {
    $('.row-offcanvas').toggleClass('active');
  });
});

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

$(document).ready(function(){

  showAndHide2($("#t-1"));
  showAndHide2($("#t-2"));
  showAndHide2($("#t-3"));
  showAndHide2($("#t-4"));
  showAndHide2($("#t-5"));
  showAndHide2($("#t-6"));
  showAndHide2($("#t-7"));
  showAndHide2($("#t-8"));
  showAndHide2($("#t-9"));

  function showAndHide2( obj )
  {
    var tile = obj;

    tile.siblings("div.t-content").css({
      position: "absolute",
      top: tile.position().top + "px",
      left: tile.position().left + "px",
      width: tile.outerWidth() + "px"
    });

    tile.parent().hover(
      function(){
        tile.find("h3").hide();
        tile.find("h4").hide();
        $(this).children("div.t-content").show();
      },
      function(){
        tile.find("h3").show();
        tile.find("h4").show();
        $(this).children("div.t-content").hide();
      }
    );
  }

});
