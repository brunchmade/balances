# Only works for keypress and keydown NOT keyup
window.isCutKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 67 and (event.ctrlKey or event.metaKey)

# Only works for keypress and keydown NOT keyup
window.isPasteKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 86 and (event.ctrlKey or event.metaKey)

# Only works for keypress and keydown NOT keyup
window.isSelectAllKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 65 and (event.ctrlKey or event.metaKey)

# Only works for keypress and keydown NOT keyup
window.isArrowKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 37 or
    event.keyCode is 38 or
    event.keyCode is 39 or
    event.keyCode is 40

window.isEnterKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 13

window.isEscapeKey = (event) ->
  if event.target.disabled
    false
  else
    event.keyCode is 27
