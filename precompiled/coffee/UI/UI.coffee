# -----------------------------------
#
# 	UI
# 
# -----------------------------------
# @codekit-prepend "../UI/UI.Browser.coffee"
# @codekit-prepend "../UI/UI.Middle.coffee"
# @codekit-prepend "../UI/UI.Toggle.coffee"
# @codekit-prepend "../UI/UI.Animator.coffee"
# @codekit-prepend "../UI/UI.Cookie.coffee"
# @codekit-prepend "../UI/UI.Modal.coffee"
# @codekit-prepend "../UI/UI.Events.Drag.coffee"
# @codekit-prepend "../UI/UI.Events.coffee"
# -----------------------------------
define 'UI', ['UI.Browser' ,'UI.Middle', 'UI.Toggle', 'UI.Animator', 'UI.Cookie', 'UI.Modal', 'UI.Events'], (Browser, Middle, Toggle, Animate, Cookie, Modal, Events) ->

	window.requestAnimationFrame = window.requestAnimationFrame or 
		window.mozRequestAnimationFrame or
		window.webkitRequestAnimationFrame or 
		window.msRequestAnimationFrame or 
		(cb) -> return setTimeout cb, 15

	window.cancelAnimationFrame = window.cancelAnimationFrame or
		window.mozCancelAnimationFrame or
		window.webkitCancelAnimationFrame or
		window.msCancelAnimationFrame or
		(timeout)-> return clearTimeout timeout

	return {
		Browser: Browser
		Middle: Middle
		Toggle: Toggle
		Animate: Animate
		Cookie: Cookie
		Modal: Modal
		Events: Events
	}
