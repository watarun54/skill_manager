$(document).on('turbolinks:load', function() {
  // クリック時、メニューを閉じる
  $('.navbar-nav a').on('click', function(){
    if($(this).attr('class').indexOf('collapse-dashboard') == -1){
      $('.navbar-collapse').collapse('hide');
    }
  });
  // 「Dashboard」のクリック時、G.S.のリストを表示する
  $('.collapse-dashboard').click(function(){
    $('.dashboard').toggleClass("open");
  });
});
