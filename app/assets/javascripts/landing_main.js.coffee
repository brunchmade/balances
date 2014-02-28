$(document).ready ->
  setHeaderHeight()
  $(window).resize =>
    setHeaderHeight()

setHeaderHeight = ->
  $header = @$(".header-bg")
  return unless $header.length > 0
  $header.height $(window).height()
  if parseInt($header.css("height")) < 890
    $header.css "height", 900 + "px"
  else
    $header.height $(window).height()
  if $(window).width() < 600
    $header.css "height", "auto"

  $callout = $header.find("h1")
  $callout.css "marginTop", ($(window).height() / 4 - $callout.height()) + "px"
  if parseInt($callout.css("marginTop")) < 0
    $callout.css "marginTop", "0"
  else
    $callout.css "marginTop", ($(window).height() / 4 - $callout.height()) + "px"

  $screen = $header.find(".screen")
  $screen.css "position", "absolute"
  $screen.css "bottom", "0"
  $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
  if parseInt($header.css("height")) < 1020
    $screen.css "position", "relative"
    $screen.css "marginTop", "20px"
  else
    $screen.css "position", "absolute"
    $screen.css "bottom", "0"
    $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
