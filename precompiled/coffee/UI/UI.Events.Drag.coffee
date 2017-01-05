#------------------------------
#
#	UI > Events > Drag
#
#------------------------------
define 'UI.Events.Drag', ['$'], ($) ->

	isAndroid = /(Android)/g.test(navigator.userAgent)

	isTouch = 'ontouchstart' of window or 'onmsgesturechange' of window

	#-------------------------------------------
	#	Drag Handler
	#-------------------------------------------
	Drag = (options) ->

		#	Configuration
		#--------------------------
		max = options.max or 6
		if options.min? then min = options.min else min = 15
		if options.preventable? then preventable = options.preventable else preventable = true

		#	NO EL OR SUFFIX?
		#--------------------------
		if !options.$el and !options.suffix
			return {
				on: ->
				trigger: ->
				off: ->
			}

		#	ELEMENTS
		#--------------------------
		doc = $ document
		control = options.$el
		suffix = options.suffix
		selector = options.selector

		#	OBSERVER
		#--------------------------
		_events = {}

		bind = (observer, callback, once) ->
			_events[observer] = _events[observer] || []
			_events[observer].push callback: callback, once: once

		remove = ->
			_events = {}

		trigger = (observer, attr1, attr2, attr3, attr4) ->
			remove = []
			if _events[observer]
				for event, i in _events[observer]
					event.callback attr1, attr2, attr3, attr4
					if event.once then remove.push i
				for r, j in remove
					_events[observer].splice r - j, 1

		once = (observer, callback) ->
			bind observer, callback, true


		#	VARIABLES
		#--------------------------
		beginX = undefined
		beginY = undefined
		previous = []
		valid = undefined
		startDate = undefined

		#	AVERAGE FINAL SPIN
		#--------------------------
		track = (e) ->
			if previous.length is max then previous.splice(0,1)
			previous.push
				pageX: e.pageX
				pageY: e.pageY
				time: new Date()

		velocity = (type) ->
			last = previous[previous.length - 1]
			first = previous[0]
			return (last[type] - first[type])/(last.time - first.time)

		distance = (type) ->
			return previous[previous.length - 1][type] - previous[0][type]

		#	CORE FUNCTIONALITY
		#--------------------------
		begin = (e) ->
			beginX = e.pageX
			beginY = e.pageY
			previous = []
			valid = undefined
			startDate = new Date()
			track(e)
			trigger('start', e.pageX, e.pageY)
			if !isTouch then doc.on 'mousemove' + suffix, (e) ->
				track e
				if isValid()
					if preventable then e.preventDefault()
					step e
			if !isTouch then doc.on 'mouseup' + suffix, (e) ->
				if preventable then e.preventDefault()
				complete e

		step = (e) ->
			trigger 'move', e.pageX - beginX, e.pageY - beginY

		complete = (e) ->
			if !isTouch then doc.off 'mousemove' + suffix + ' mouseup' + suffix
			velocityX = if isValid() then velocity('pageX') else 0
			velocityY = if isValid() then velocity('pageY') else 0
			cx = Math.abs distance('pageX')
			cy = Math.abs distance('pageY')
			duration = new Date() - startDate
			if cx >= min or cy >= min or duration > 500 then trigger 'end', velocityX, velocityY, duration, e

		#	VALIDATE PAN
		#--------------------------
		if options.prevent is 'y'
			isValid = ->
				if typeof valid is 'boolean' then return valid
				else if previous.length > 1 and isAndroid then valid = Math.abs(distance('pageX'))/Math.abs(distance('pageY')) > 0.5
				else if previous.length < 3 then return false
				else valid = Math.abs(distance('pageX'))/Math.abs(distance('pageY')) > 1
				return valid
		else if options.prevent is 'x'
			isValid = ->
				if typeof valid is 'boolean' then return valid
				else if previous.length < 3 then return false
				else valid = Math.abs(distance('pageY'))/Math.abs(distance('pageX')) > 1
				return valid
		else
			isValid = -> return true

		#	IOS TOUCH EVENTS
		#--------------------------
		if control[0] and control[0].addEventListener
			control.on 'touchstart' + suffix, selector, (e) ->
				e = e.originalEvent
				begin e.targetTouches[0]
			control.on 'touchmove' + suffix, selector, (e) ->
				e = e.originalEvent
				track e.targetTouches[0]
				if isValid()
					if preventable then e.preventDefault()
					step e.targetTouches[0]
			control.on 'touchend' + suffix, selector, (e) ->
				complete e

		#	MS TOUCH EVENTS
		#--------------------------
		msprevent = ->
			if selector? then c = control.find(selector)
			else c = control
			if options.prevent is 'y' then c.css '-ms-touch-action', 'pan-y'
			else if options.prevent is 'x' then c.css '-ms-touch-action', 'pan-x'
			else c.css '-ms-touch-action', 'none'
			return c

		#	MS IE11
		#--------------------------
		if navigator.pointerEnabled or navigator.msPointerEnabled

			c = msprevent()

			move = (e) ->
				track e
				if isValid()
					if preventable then e.preventDefault()
					step e

			up = (e) ->
				complete e
				window.removeEventListener 'MSPointerMove', move
				window.removeEventListener 'MSPointerUp', up

			c.each () ->
				el = $(@)[0]
				el.addEventListener 'MSPointerDown', (e) ->
					begin e
					window.addEventListener 'MSPointerMove', move
					window.addEventListener 'MSPointerUp', up


		else
			#	DRAG EVENTS
			#--------------------------
			if !isTouch
				control.on 'mousedown' + suffix, selector, (e) ->
					if e.button isnt 2
						if preventable then e.preventDefault()
						begin e

		return {
			on: bind
			off: remove
			trigger: trigger
			once: once
		}
