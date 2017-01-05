# -----------------------------------
#
# 	Header
#
# -----------------------------------
define 'BE.Views.Header', ['View'], (View) ->

	class Header extends View

		initialize: ->
			@model.on 'change:nav', @nav, @

		create: (@$el) ->
			@delegateEvents()

		nav: () ->
			previous = @model.previous 'nav'
			if !previous? then previous = 'start'
			current = @model.get 'nav'
			@$el.attr 'class', 'to-' + current + ' from-' + previous + ' visible'

		events:
			'click .mobile-toggle': (e) ->
				e.preventDefault()
				@model.set menu: !@model.get 'menu'
			'click .navigate': (e) ->
				e.preventDefault()
				anchor = $(e.currentTarget)
				@model.navigate(anchor.data('to'), anchor.data('direction'))
			'click .back': (e) ->
				e.preventDefault()
				@model.back()
			'click .close': (e) ->
				e.preventDefault()
				@model.trigger 'close'
			'click .reset': (e) ->
				$('.current').removeClass('current')
				$(e.target).addClass('current')
				@model.trigger 'reset'
