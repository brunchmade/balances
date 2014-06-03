$(function() {
  var $window = $(window);
  var $headerBg = $('.header-bg')

  $window.resize(function() {
    $headerBg.height($window.height() - $headerBg.offset().top);
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
