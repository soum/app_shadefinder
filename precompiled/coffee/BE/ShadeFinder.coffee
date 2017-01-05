# -----------------------------------
#
# 	Shade Finder
#
# -----------------------------------
# @codekit-prepend "../UI/UI.coffee"
# @codekit-prepend "Framework/Models/Logic.coffee"
# @codekit-prepend "Framework/Models/Page.coffee"
# @codekit-prepend "Framework/Models/Intro.coffee"
# @codekit-prepend "Framework/Models/Resolve.coffee"
# @codekit-prepend "Framework/Models/Shade.coffee"
# @codekit-prepend "Framework/Models/Product.coffee"
# @codekit-prepend "Framework/Models/VideoModal.coffee"
# @codekit-prepend "Framework/Models/Cart.coffee"
# @codekit-prepend "Framework/Models/MobileFinish.coffee"
# @codekit-prepend "Framework/Views/Header.coffee"
# @codekit-prepend "Framework/Views/Progress.coffee"
# @codekit-prepend "Framework/Views/Page.coffee"
# @codekit-prepend "Framework/Views/Intro.coffee"
# @codekit-prepend "Framework/Views/Match.coffee"
# @codekit-prepend "Framework/Views/Resolve.coffee"
# @codekit-prepend "Framework/Views/Shade.coffee"
# @codekit-prepend "Framework/Views/Product.coffee"
# @codekit-prepend "Framework/Views/VideoModal.coffee"
# @codekit-prepend "Framework/Views/MobileNav.coffee"
# @codekit-prepend "Framework/Views/MobileFinish.coffee"
# @codekit-prepend "Framework/Collections/Shade.coffee"
# @codekit-prepend "Framework/Collections/Product.coffee"
# @codekit-prepend "ShadeFinder/States.coffee"
# @codekit-prepend "ShadeFinder/Logic.coffee"
# @codekit-prepend "ShadeFinder/Page.coffee"
# @codekit-prepend "ShadeFinder/Resolve.coffee"
# @codekit-prepend "ShadeFinder/Shade.coffee"
# @codekit-prepend "ShadeFinder/Product.coffee"
# @codekit-prepend "ShadeFinder/Header.coffee"
# @codekit-prepend "ShadeFinder/Intro.coffee"
# @codekit-prepend "ShadeFinder/Progress.coffee"
# @codekit-prepend "ShadeFinder/Match.coffee"
# @codekit-prepend "ShadeFinder/Filters.coffee"
# @codekit-prepend "ShadeFinder/Reset.coffee"
# @codekit-prepend "ShadeFinder/VideoModal.coffee"
# @codekit-prepend "ShadeFinder/Cart.coffee"
# @codekit-prepend "ShadeFinder/MobileNav.coffee"
# @codekit-prepend "ShadeFinder/Tracking.coffee"
# @codekit-prepend "ShadeFinder/MobileFinish.coffee"
# @codekit-prepend "ShadeFinder/TipsModal.coffee"
# @codekit-prepend "ShadeFinder/TouchHovers.coffee"
# @codekit-prepend "Overrides/StaticStates.coffee"
# @codekit-prepend "Overrides/Backbone.Events.coffee"
# ------------------------------------
define '$', () -> return $
define 'Model', () -> return Backbone.Model
define 'View', () -> return Backbone.View
define 'Collection', () -> return Backbone.Collection

require [
	'Backbone.Events', '$', 'UI', 'BE.Page',
	'BE.Logic', 'BE.Shades', 'BE.Resolve', 'BE.Products', 'BE.Header', 'BE.Intro', 'BE.Progress', 'BE.Match', 'BE.Filters', 'BE.Reset',
	'BE.VideoModal', 'BE.Cart', 'BE.MobileNav', 'BE.Tracking', 'BE.MobileFinish', 'BE.TipsModal', 'BE.TouchHovers'
], (Events, $, UI, page) ->

	iframed = ->
		try
			return window.self isnt window.top
		catch error
			return true

	forceRefresh = UI.Browser.debounce ->
		$('<style></style>').appendTo($(document.body)).remove()
	, 400

	window.hijackjQuery = (prop) ->
		original = $.fn[prop]
		$.fn[prop] = ->
			original.apply @, arguments
			forceRefresh()

	if (UI.Browser.is.android() and UI.Browser.isnt.chrome())
		for hijack in ['html', 'height', 'css']
			hijackjQuery hijack

	$ ->

		mainSections = $('main, body, html')

		frame = undefined

		UI.Browser.on 'resize', (o) ->
			cancelAnimationFrame frame
			frame = requestAnimationFrame ->
				mainSections.css height: o.height, width: o.width
			$('section').each ->
				$(@).css height: o.height
				if $(@).hasClass 'progress-section'
					$(@).css width: o.width - 60
				else
					$(@).css width: o.width

		UI.Browser.on 'change:input', ->
			prev = UI.Browser.previous 'input'
			next = UI.Browser.get 'input'
			$('html').removeClass('has-' + prev).addClass 'has-' + next

		$('.middle').each ->
			new UI.Middle().trigger 'create', $ @

		if UI.Browser.is.windows() and UI.Browser.is.firefox() then $('html').addClass('windows-firefox')
		else if UI.Browser.is.windows() and UI.Browser.is.chrome() then $('html').addClass('windows-chrome')
		else if UI.Browser.is.android() and UI.Browser.isnt.chrome() then $('html').addClass('stock-android')
		else if UI.Browser.is.IE10() then $('html').addClass('ie10')
		else if UI.Browser.is.IE9() then $('html').addClass('ie9')
		else if UI.Browser.is.IE8() then $('html').addClass('ie8')

		if iframed() then $('html').addClass('in-iframe')
		else $('html').addClass('no-iframe')

	load = ->

		UI.Browser.resize()

		setTimeout ->
			page.trigger 'change:state loaded', page, page.get 'state'
		, 400


	if iframed()
		parent.ShadeFinder.load load
		page.on 'close', ->
			parent.ShadeFinder.close()
	else
		if document.readyState is 'complete' then load()
		else window.onload = load
