# -----------------------------------
#
# 	UI > Browser
#
# -----------------------------------
define 'UI.Browser', ['$', 'Model'], ($, Model) ->

	#----------------------------
    # 	Memoize
   	#----------------------------
	memoize = (func) ->
		memo = {}
		(arg) ->
			memo[arg] = func arg unless memo[arg]
			memo[arg]

	#----------------------------
    # 	Memoize the has utility
   	#----------------------------
	has = (prop) ->
		div = document.createElement 'div'
		vendors = ['Khtml', 'ms', 'O', 'Moz', 'Webkit']
		length = vendors.length
		test = (prop) ->
			return prop if prop of div.style
			prop = prop.replace /^[a-z]/, (val) ->
				return val.toUpperCase()
			while length--
				if vendors[length] + prop of div.style
					return '-' + vendors[length].toLowerCase() + '-' + prop.toLowerCase();
		return test(prop)


    #----------------------------
    # 	The Model
   	#----------------------------
	class Browser extends Model

		defaults:
			breakpoints: {}
			breakpoint: undefined
			hasMouse: undefined

		initialize: () ->
			@win = $ window
			@doc = $ document
			@win.resize () =>
				cancelAnimationFrame @frame
				@frame = requestAnimationFrame =>
					@resize()
			@win.scroll () => @scroll()
			mouseend = @debounce =>
				@mouseend()
			, 400
			@doc.on 'mousemove', (e) =>
				@mousemove(e)
				mouseend()
			@doc.on 'touchmove', (e) => @touchmove(e)
			@doc.on 'touchend', (e) => @touchend(e)

		is:
			IOS: -> return /(iPad|iPhone|iPod)/g.test(navigator.userAgent)
			touch: -> return 'ontouchstart' of window or 'onmsgesturechange' of window
			retina: -> return window.devicePixelRatio > 1
			firefox: -> return /(Firefox)/g.test(navigator.userAgent)
			windows: -> return /(Windows)/g.test(navigator.userAgent)
			chrome: -> return /(Chrome)/g.test(navigator.userAgent)
			android: -> return /(Android)/gi.test(navigator.userAgent)
			IE10: -> return /(MSIE 10)/g.test(navigator.userAgent)
			IE9: -> return /(MSIE 9)/g.test(navigator.userAgent)
			IE8: -> return /(MSIE 8)/g.test(navigator.userAgent)

		isnt:
			IOS: -> return !/(iPad|iPhone|iPod)/g.test(navigator.userAgent)
			touch: -> return !'ontouchstart' of window and !'onmsgesturechange' of window
			retina: -> return window.devicePixelRatio <= 1
			firefox: -> return !/(Firefox)/g.test(navigator.userAgent)
			windows: -> return !/(Windows)/g.test(navigator.userAgent)
			chrome: -> return !/(Chrome)/g.test(navigator.userAgent)
			android: -> return !/(Android)/gi.test(navigator.userAgent)
			IE10: -> return !/(MSIE 10)/g.test(navigator.userAgent)
			IE9: -> return !/(MSIE 9)/g.test(navigator.userAgent)
			IE8: -> return !/(MSIE 8)/g.test(navigator.userAgent)

		breakpoint: (breakpoints) ->
			@set breakpoints: breakpoints
			@on 'resize', (d) =>
				for key, width of @get 'breakpoints'
					if width > d.width
						@set breakpoint: key
						break
			return @

		data: ->
			win = @win
			top = @doc.scrollTop()
			height = win.height()
			innerHeight = window.innerHeight
			if innerHeight < height then height = innerHeight
			width = win.width()
			return top: top, height: height, width: width, center: top + height/2, bottom: top + height

		resize: () ->
			@trigger 'resize', @data()
			clearTimeout @transitionTimeout
			@transitionTimeout = setTimeout =>
				@trigger 'resize', @data()
			, 500
			return @

		scroll: ->
			@trigger 'scroll', top: @doc.scrollTop()
			return @

		mousemove: (e) ->
			@mousing = @mousing or [e.pageX, e.pageY]
			if (Math.abs(e.pageX - @mousing[0]) + Math.abs(e.pageY - @mousing[1])) > 40
				@set input: 'mouse'

		mouseend: (e) ->
			delete @mousing

		touchmove: (e) ->
			touch = e.originalEvent.touches[0]
			@touching = @touching or [touch.pageX, touch.pageY]
			if (Math.abs(touch.pageX - @touching[0]) + Math.abs(touch.pageY - @touching[1])) > 40
				@set input: 'touch'

		touchend: (e) ->
			delete @touching

		memoize: memoize

		has: memoize has

		debounce: (func, wait, immediate) ->
			timeout = undefined
			args = undefined
			context = undefined
			timestamp = undefined
			result = undefined
			return () ->
				context = @
				args = arguments
				timestamp = new Date()
				later = () =>
					last = (new Date()) - timestamp
					if last < wait then timeout = setTimeout later, wait - last
					else
						timeout = null
						if !immediate then result = func.apply(context, args)
				callNow = immediate && !timeout
				if !timeout then timeout = setTimeout(later, wait)
				if callNow then result = func.apply(context, args)
				result

		dedupe: (func, wait, alt) ->
			time = 0
			return () ->
				context = @
				if new Date() - time > wait
					func.apply context, arguments
					time = new Date()
				else if alt? then alt.apply context, arguments

		transform: (type, dist) ->
			transform = @has('transform')
			if transform
				switch type
					when 'left' then return [transform, 'translateX(' + dist + ')']
					when 'top' then return [transform, 'translateY(' + dist + ')']
			else
				switch type
					when 'left' then return ['left', dist]
					when 'top' then return ['top', dist]

		listen: (el, type, callback) ->
			pfx = ["webkit", "moz", "MS", "o", ""]
			for p in [0..pfx.length]
				if !pfx[p] then type = type.toLowerCase()
				if typeof el.addEventListener is 'function' then el.addEventListener pfx[p] + type, callback, false


	new Browser()
