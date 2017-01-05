# -----------------------------------
#
# 	Mobile Nav
#
# -----------------------------------
define 'BE.Views.MobileNav', ['View'], (View) ->

	class MobileNav extends View

		initialize: ->
			@model.on 'change:menu', @toggle, @

		create: (@$el) ->
			@delegateEvents()

		toggle: ->
			if @model.get 'menu' then @show() else @hide()

		show: ->
			@$el.removeClass('hidden').addClass 'visible'

		hide: ->
			@$el.removeClass 'visible'
			setTimeout =>
				@$el.addClass 'hidden'
			, 400

		events:
			'click .navigate': (e) ->
				e.preventDefault()
				@model.set menu: false
				setTimeout =>
					anchor = $(e.currentTarget)
					@model.navigate(anchor.data('to'), anchor.data('direction'))
				, 400

			'click .back': (e) ->
				e.preventDefault()
				@model.back()
			'click .reset': (e) ->
				e.preventDefault()
				@model.set menu: false
				setTimeout =>
					@model.trigger 'reset'
				, 400
			# 'click .dot': (e) ->
			# 	@model.set menu: false
