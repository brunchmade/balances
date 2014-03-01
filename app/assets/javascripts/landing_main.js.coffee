$(document).ready ->
  setHeaderHeight()
  $(window).resize =>
    setHeaderHeight()

setHeaderHeight = ->
  $header = @$(".header-bg")
  return unless $header.length > 0
  $header.height $(window).height()
  if parseInt($header.css("height")) < 749
    $header.css "height", 750 + "px"
  else
    $header.height $(window).height()
  if $(window).width() < 599
    $header.css "height", "auto"

  $callout = $header.find("h2")
  $callout.css "marginTop", ($(window).height() / 5 - $callout.height()) + "px"
  if parseInt($callout.css("marginTop")) < 0
    $callout.css "marginTop", "0"
  else
    $callout.css "marginTop", ($(window).height() / 5 - $callout.height()) + "px"

  $screen = $header.find(".screen")
  $screen.css "position", "absolute"
  $screen.css "bottom", "0"
  $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
  if parseInt($header.css("height")) < 750
    $screen.css "position", "relative"
    $screen.css "marginTop", "20px"
  else
    $screen.css "position", "absolute"
    $screen.css "bottom", "0"
    $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
