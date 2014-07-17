$(function() {
  var $window = $(window);
  var $headerBg = $('.header-bg')
  var $screenImg = $('.screen img')

  $window.resize(function() {
    if($window.width() > 600) {
      $headerBg.height($window.height() - $headerBg.offset().top);
    } else {
      $headerBg.height('auto')
    }

    if($window.width() >= 830) {
      $screenImg.height($window.height() / 1.9);
    } else if($window.width() < 600) {
      $screenImg.height('');
    }
    else {
      $screenImg.height($window.height() / 2.4);
    }
  });
  $window.resize();

  new WOW().init();
});


$('.scroll-to').click(function(event) {
  event.preventDefault();
  var destination = $(this).data('scroll-to');
  $('html, body').animate({
    scrollTop: $(destination).offset().top
  }, 700);
});
