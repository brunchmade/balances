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


$('.scroll-to').click(function(event) {
  event.preventDefault();
  var destination = $(this).data('scroll-to');
  $('html, body').animate({
    scrollTop: $(destination).offset().top
  }, 700);
});
