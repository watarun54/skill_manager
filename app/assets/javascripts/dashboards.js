$(document).on('turbolinks:load', function() {
  $('.dropdown-menu .nav-link').click(function(){
    var visibleItem = $('#period-button');
    visibleItem.text($(this).text());
  });
});
