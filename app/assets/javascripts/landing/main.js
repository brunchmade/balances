$(function(){ $(document).foundation(); });

$(function() {
    $(window).resize(function() {
        $('.header-bg').height($(window).height() - $('.header-bg').offset().top);
    });
    $(window).resize();
});

new WOW().init();

$(".read-more").click(function() {

    $('html, body').animate({
        scrollTop: $("#unified-bg").offset().top
    }, 1000);

});
