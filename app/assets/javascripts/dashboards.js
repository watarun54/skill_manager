$(document).on('turbolinks:load', function() {
  $('#score-period-button-group .nav-link').click(function(){
    var scorePeriodButton = $('#score-period-button');
    scorePeriodButton.text($(this).text());
  });
  $('#skill-period-button-group .nav-link').click(function(){
    var skillPeriodButton = $('#skill-period-button');
    skillPeriodButton.text($(this).text());
  });
  $('#charts-by-skill-period-button-group .nav-link').click(function(){
    var skillPeriodButton = $('#charts-by-skill-period-button');
    skillPeriodButton.text($(this).text());
  });
});
