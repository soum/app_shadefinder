# -----------------------------------
#
# 	Shade Finder Modal
#
# -----------------------------------
ShadeFinder =

	$el: $ '<div class="shade-finder"></div>'

	$iframe: $ '<iframe class="shade-finder-iframe" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'

	attributes:
		replace: false
		loading: false
		url: '/on/demandware.store/Sites-BareMinerals_US_CA-Site/default/ShadeFinder-Show'
		callback: undefined
		baseUrl: location.pathname
		hash: '#ShadeFinder-Show'
		hasPush: history && history['pushState']

	pushState: () ->
		if @attributes.hasPush
			if $.trim(location.hash) isnt @attributes.hash
				history.pushState { d: 'Open Shade Finder' }, "Shade Finder",  @attributes.baseUrl + @attributes.hash
		return @

	startState: () ->
		if @attributes.hasPush
			history.replaceState { d: 'Closed' }, null,  @attributes.baseUrl
			@open()
		else @open()
		return @

	create: (container) ->
		first = true
		container.append @$el
		if $.trim(location.hash) is @attributes.hash
			@startState()
		if @attributes.hasPush
			window.onpopstate = (e) =>
				if !first
					if !e.state? or (e.state.d? and e.state.d is 'Closed') then @hide()
					else @open(false)
				first = false

	load: (callback) ->
		@attributes.callback = callback;

	loaded: ->
		if @attributes.callback && typeof @attributes.callback is 'function' then @attributes.callback()

	loading: (value) ->
		if value
			@attributes.loading = value
			return @
		else return @attributes.loading

	url: (value) ->
		if value
			@attributes.url = value
			return @
		else return @attributes.url

	open: (push) ->
		if push isnt false then @pushState()
		if !@loading()
			@loading(true).append().show().render () =>
				setTimeout =>
					@loaded()
				, 200
		else
			@show()

	close: ->
		# if @attributes.hasPush then history.back()
		# else @hide()
		history.back()
		@hide()
		if /(iPad)/g.test(navigator.userAgent)
			$('meta[data-shadefinder=true]').remove();
		return @

	hide: ->
		$('html').removeClass('shade-finder-shown')
		@$el.removeClass('show').addClass('hide')
		if app && app.minicart && typeof app.minicart.add2 is 'function'
			if !invokeCoremetrics_addProdToBag2? then window.invokeCoremetrics_addProdToBag2 = () ->
			app.minicart.add2('','','','null');
		return @

	show: ->
		$('html').addClass('shade-finder-shown')
		@$el.removeClass('hide').addClass('show')
		return @

	append: ->
		win = $ window
		width = win.width()
		height = win.height()
		if /(iPad)/g.test(navigator.userAgent) && (height > width)
			$('head').append('<meta name="viewport" data-shadefinder="true" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">');
		@$iframe.attr('height', height).attr('width', width)
		@$el.append(@$iframe)
		return @

	render: (callback) ->
		@$iframe.load ->
			callback()
		@$iframe[0].contentWindow.location.replace(@url())

$ ->

	ShadeFinder.create $ 'body'

	$('.show-shadefinder, .bm_sub_foundation_finder, .be_sub_foundation_finder').click (e) ->
		e.preventDefault()
		if /(MSIE 8)/g.test(navigator.userAgent)
			window.open ShadeFinder.attributes.url, '_blank', 'menubar=no,toolbar=no,titlebar=no,status=no,location=no,resizable=yes'
		else
			ShadeFinder.open()

	if /(MSIE 8)/g.test(navigator.userAgent)
		$(window).on 'focus', () ->
			ShadeFinder.hide()



window.ShadeFinder = ShadeFinder
