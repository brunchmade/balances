$(document).ready ->
  setHeaderHeight()
  $(window).resize =>
    setHeaderHeight()

setHeaderHeight = ->
  $header = @$(".header-bg")
  return unless $header.length > 0
  $header.height $(window).height()

  $callout = $header.find("h1")
  $callout.css "marginTop", ($(window).height() / 4 - $callout.height() - 30) + "px"
  if parseInt($callout.css("marginTop")) < 0
    $callout.css "marginTop", "0"
  else
    $callout.css "marginTop", ($(window).height() / 4 - $callout.height() - 30) + "px"

  $screen = $header.find(".screen")
  $screen.css "position", "absolute"
  $screen.css "bottom", "0"
  $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
  if parseInt($header.css("height")) < 805
    $screen.css "position", "relative"
    $screen.css "marginTop", "0"
  else
    $screen.css "position", "absolute"
    $screen.css "bottom", "0"
    $screen.css "margin-left", (- $screen.width() / 2 - 37) + "px"
