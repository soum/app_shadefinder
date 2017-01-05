# -----------------------------------
#
# 	Intro
# 
# -----------------------------------
define 'BE.Models.Intro', ['UI', 'Model'], (UI, Model) ->

	Browser = UI.Browser
	Animate = UI.Animate

	class Intro extends Model

		defaults: 
			position: 0
			page: undefined
			height: undefined
			visible: true

		initialize: ->
			Browser.on 'resize', @resize, @
			@on 'change:position', @visible, @
			$(window).on 'mousewheel DOMMouseScroll', (e) =>
				if @get('page') is 0 or @get('page') is 1
					e.preventDefault()
					@stop()
					if e.originalEvent.wheelDelta? then delta = e.originalEvent.wheelDelta / 2
					else if e.originalEvent.deltaY? then delta = e.originalEvent.deltaY
					else if e.originalEvent.detail? then delta = -e.originalEvent.detail * 8
					position = @get('position') + delta/@get('height')
					if position > 0 then position = 0
					else if position < -1 then position = -1
					@set position: position
			@on 'change:page', @page

		resize: (o) ->
			@set height: o.height

		visible: ->
			position = @get 'position'
			if position < -0.25 then @set visible: false
			else @set visible: true

		stop: ->
			if @animation? then @animation.stop()

		animateOut: ->
			@stop()
			position = @get 'position'
			@animation = Animate position, -1, (position + 1) * 800, undefined, (position) =>
				@set position: position

		page: ->
			if @get('page') > 1 and @get('position') isnt -1
				@animateOut()

