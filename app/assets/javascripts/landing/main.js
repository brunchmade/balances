$(function() {
  var $window = $(window);
  var $headerBg = $('.header-bg')
  var $screenImg = $('.screen img')

  $window.resize(function() {
    $headerBg.height($window.height() - $headerBg.offset().top);

    if($window.width() >= 830) {
      $screenImg.height($window.height() / 1.9);
    } else {
      $screenImg.height($window.height() / 2.4);
    }
  });
  $window.resize();

  $(document).foundation();
  new WOW().init();
});


$('.read-more').click(function(event) {
  event.preventDefault();

  $('html, body').animate({
    scrollTop: $('#unified-bg').offset().top
  }, 1000);
});
