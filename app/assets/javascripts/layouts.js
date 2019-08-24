$(document).on('turbolinks:load', function() {
  $('.collapse-dashboard').click(function(){
    $('.dashboard').toggleClass("open");
  });
});
