#------------------------------
#
#	UI > Events
#
#------------------------------
define 'UI.Events', ['UI.Events.Drag', 'UI.Browser', '$'], (Drag, Browser, $) ->

	time = 0
	target = undefined

	Events = 

		Drag: Drag

		touch: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector
			@_drag.on 'start', callback

		touching: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector
			@_drag.on 'move', callback

		touched: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector
			@_drag.on 'end', callback
			delete @_drag;

		swipe: (suffix, selector, callback)->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'y'
			@_drag.on 'start', callback

		swiping: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'y'
			@_drag.on 'move', callback

		swiped: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'y'
			@_drag.on 'end', callback
			delete @_drag;

		pan: (suffix, selector, callback)->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'x'
			@_drag.on 'start', callback

		panning: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'x'
			@_drag.on 'move', callback

		panned: (suffix, selector, callback) ->
			if !@_drag then @_drag = Drag $el: @$el, suffix: suffix, selector: selector, prevent: 'x'
			@_drag.on 'end', callback
			delete @_drag;

		tap: (suffix, selector, callback) ->
			@$el.on 'mousedown' + suffix, selector, (e) =>
				x0 = e.pageX
				y0 = e.pageY
				if e.which is 1
					timeout = setTimeout =>
						@$el.off 'mouseup' + suffix
					, 500
					@$el.one 'mouseup' + suffix, selector, (e) ->
						x1 = e.pageX
						y1 = e.pageY
						cx = Math.abs x1 - x0
						cy = Math.abs y1 - y0
						if cx < 15 and cy < 15 then callback(e)

		hold: (suffix, selector, callback) ->
			@$el.on 'mousedown' + suffix, selector, ->
				timeout = setTimeout ->
					callback()
				, 1000
				$(document).one 'mouseup', -> 
					clearTimeout timeout

	if Browser.is.IOS() or Browser.is.android()

		Events.click = (suffix, selector, callback) ->
			bind = =>
				@$el.off 'click' + suffix + ' mousedown' + suffix + ' touchstart' + suffix + ' touchmove' + suffix + ' touchend' + suffix, selector
				input = Browser.get('input') || 'touch'
				switch input
					when 'mouse'
						@$el.on 'click' + suffix, selector, callback
					when 'touch' 
						@_drag = Drag $el: @$el, suffix: suffix, selector: selector, min: 0, preventable:false, ms: false
						@_drag.on 'end', (a,b,c,e) ->
							if c < 200 && isNaN(a) && isNaN(b) then callback e
			bind()
			Browser.on 'change:input', bind
			@unlisten.push ->
				Browser.off 'change:input', bind

	return Events