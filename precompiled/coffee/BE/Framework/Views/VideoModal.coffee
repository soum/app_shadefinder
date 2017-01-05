# -----------------------------------
#
# 	Shadefinder > Modal
#
# -----------------------------------
define 'BE.Views.VideoModal', ['View'], (View) ->

	class VideoModal extends View

		template: _.template '' +
			'<div class="video-player">' +
				'<div class="wrapper">' +
					'<div class="wrapper-inner">' +
						'<iframe src="<%= baseUrl %><%= video %>&h=<%= height %>&w=<%= width %>" scrolling="no" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>' +
					'</div>' +
				'</div>' +
			'</div>'

		youtubeTemplate: _.template '' +
			'<div class="video-player">' +
				'<div class="wrapper">' +
					'<div class="wrapper-inner">' +
						'<iframe src="<%= video %>&autoplay=1" scrolling="no" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>' +
					'</div>' +
				'</div>' +
			'</div>'

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'change:state', @state, @
			@model.on 'show', @show, @

		create: (@$el) ->
			@delegateEvents()

		state: ->
			current = @model.get 'state'
			previous = @model.previous 'state'
			@$el.removeClass(previous).addClass(current)

		show: ->
			win = $ window
			width = win.width()
			idealheight = width * 9/16
			maxheight = win.height() - 140
			if idealheight > maxheight
				height = maxheight
				width = maxheight * 16/9
			else
				height = idealheight
			@model.set height: height, width: width


			blah = @$el.find('.video-player')

			if @$el.find('.video-player').length is 0
				if /youtube.com/.exec @model.get('video') then @$el.append @youtubeTemplate @model.attributes
				else @$el.append @template @model.attributes
			@$el.find('.video-player').height(height).find('.wrapper').width(width)
			@model.once 'hide', =>
				@$el.find('.video-player').remove()

		events:
			'click .hide' : (e) ->
				e.preventDefault()
				@model.trigger 'hide'
			'click .overlay': (e) ->
				e.preventDefault()
				@model.trigger 'hide'
