# -----------------------------------
#
# 	Intro
# 
# -----------------------------------
define 'BE.Views.Intro', ['UI', 'View'], (UI, View) ->

	Browser = UI.Browser

	class IntroView extends View

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'fade', @fade, @

		create: (@$el) ->
			@delegateEvents()
			@model.on 'change:position', @position, @

		fade: (@$next) ->
			@model.on 'change:position', @fading, @

		position: ->
			position = @model.get 'position'
			transform = UI.Browser.transform 'top', position * 100 + '%'
			@$el.css transform[0], transform[1]

		fading: ->
			position = @model.get 'position'
			@$next.css 'opacity', -position

		animateOut: (e) ->
			e.preventDefault()
			@model.animateOut()

		events: 
			'click .start': 'animateOut'
			
