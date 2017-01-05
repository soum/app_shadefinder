# -----------------------------------
#
# 	Shades
#
# -----------------------------------
define 'BE.Views.Shade', ['UI', 'View', 'BE.Logic'], (UI, View, logic) ->

	Browser = UI.Browser

	class ShadeView extends View

		template: _.template '' +
			'<div class="shade shade-<%= id %> undertones-<%= _.size(options) %>" data-value="<%= id %>" data-category="Shade">' +
				'<div class="background">' +
					'<div class="buttons">' +
						'<% _.each(options, function(option, j) { %>' +
							'<% var cssClass = j.toLowerCase().replace(/\\s/gi, "-"); %>' +
							'<% console.log(j); %>' +
							'<% var y = ShadeFinder.undertones[j]; %>' +
 							'<div class="example navigate undertone" data-value="<%= j %>" data-category="<%= family %> Undertone">' +
								'<div class="image <%= id.toLowerCase() %>-<%= cssClass %>"></div>' +
								'<div class="button-wrap">' +
									'<% if (y) { %>' +
										'<div class="undertone-button" style="background-color: <%= y.color %>;">' +
											'<div class="undertone-button-inner">' +
												'<span class="title"><%= y.title %></span>' +
												'<span class="subtitle"><%= y.description %></span>' +
												'<span class="subtitle"><%= y.undertone %></span>' +
											'</div>' +
										'</div>' +
									'<% } %>' +
								'</div>' +
							'</div>' +
						'<% }); %>' +
					'</div>' +
				'</div>' +
				'<div class="toggle">' +
					'<h4><%= id %></h4>' +
				'</div>' +
			'</div>'

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'destroy', @destroy, @
			@model.on 'change:active', @active, @
			Browser.on 'resize', @resize, @
			@model.collection.on 'render', @resize, @
			@model.on 'change:top', @top, @
			@model.collection.on 'undertoned', @undertoned, @
			@model.set family: logic.get('family')[0].toUpperCase()

		create: (container) ->
			container.append @template @model.attributes
			shades = container.find('.shade')
			@$el = shades.last()
			@delegateEvents()
			@active @model, @model.get('active')
			@resize()
			@top()
			@model.on 'resized', Browser.debounce () =>
				@resized()
			, 400

		destroy: ->
			@undelegateEvents()

		resize: ->
			@model.set
				innerHeight: @$el.find('.buttons').outerHeight(true)
				toggleHeight: @$el.find('.toggle').outerHeight()
			@model.trigger 'resized'

		resized: ->
			max = 0
			@$el.find('.undertone-button-inner').each () ->
				height = $(@).outerHeight(true)
				if height > max then max = height
			if max > 10 then @$el.find('.undertone-button').height max

		top: ->
			transform = Browser.transform 'top', @model.get('top') + 'px'
			@$el.css transform[0], transform[1]

		active: (a, active) ->
			if active
				@$el.addClass('active')
				@$el.parent().addClass 'active-' + @model.id
			else
				@$el.removeClass('active')
				@$el.parent().removeClass 'active-' + @model.id

		undertoned: (undertone) ->
			@$el.find('.undertone').removeClass('selected').end().find('[data-value="' + undertone + '"]').addClass('selected')

		events:
			'click .toggle': (e) ->
				e.preventDefault()
				@model.set active: true
			'click .undertone': (e) ->
				e.preventDefault()
				@model.set undertone: $(e.currentTarget).data('value')
				@model.trigger 'undertone', $(e.currentTarget).data('value')
