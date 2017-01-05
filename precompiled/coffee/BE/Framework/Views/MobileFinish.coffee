# -----------------------------------
#
# 	Mobile Finish
# 
# -----------------------------------
define 'BE.Views.MobileFinish', ['View', 'UI'], (View, UI) ->

	Browser = UI.Browser

	class MobileFinish extends View

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'change:position', @position, @
			@model.on 'change:tutoring', @tutoring, @

		create: (@$el) ->
			@delegateEvents()
			@tutor = @$el.parent().find '.tutor-wrap'

		tutoring: (a,b) ->
			if b then @$el.parent().addClass 'display-tutoring tutoring'
			else 
				@$el.parent().removeClass 'tutoring'
				setTimeout =>
					@$el.parent().removeClass 'display-tutoring'
				, 400


		position: (a, b) ->
			transform = Browser.transform 'left', -b/3 * 100 + '%'
			@$el.css transform[0], transform[1]
			if @model.get 'tutoring'
				transform = Browser.transform 'left', (b - 1) * -50 + '%'
				@tutor.css transform[0], transform[1]


		swipe: () ->
			@changed = false

		swiping: (a, b) ->
			if a < -50 and !@changed 
				@changed = true
				@model.next()
			else if a > 50 and !@changed 
				@changed = true
				@model.prev()

		swiped: ->

		events: 
			'swipe': 'swipe'
			'swiping': 'swiping'
			'swiped': 'swiped'
