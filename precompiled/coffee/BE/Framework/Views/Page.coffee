# -----------------------------------
#
# 	Intro
#
# -----------------------------------
define 'BE.Views.Page', ['$', 'UI', 'View'], ($, UI, View) ->

	Browser = UI.Browser

	class PageView extends View

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'change:state', @state, @
			@model.on 'change:menu', @menu, @
			@model.on 'change:page', @page, @

		create: (@$el) ->
			@body = $ 'body'
			@delegateEvents(@events)
			Browser.listen @body[0], 'AnimationEnd', (e) =>
				@model.set animation: e.animationName

		state: ->
			previous = @model.previous 'state'
			if !previous? then previous = 'start'
			current = @model.get 'state'
			if @body then @body.attr 'class', 'show from-' + previous + ' to-' + current

		menu: ->
			if @model.get 'menu' then $('html').addClass('menu-open').removeClass('menu-closed')
			else $('html').addClass('menu-closed').removeClass('menu-open')

		page: ->
			previous = @model.previous 'page'
			if !previous? then previous = 'start'
			current = @model.get 'page'
			@$el.attr 'class', 'from-page-' + previous + ' to-page-' + current

		events:
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
			'click .reset': () ->
				@model.trigger 'reset'
			'click .video': (e) ->
				video = $(e.currentTarget).data('video')
				@model.trigger 'video', video
			'click .print': (e) ->
				e.preventDefault()
				window.print()
