# -----------------------------------
#
# 	UI > Toggle
#
# -----------------------------------
define 'UI.Toggle', ['$', 'Model', 'View', 'Collection', 'UI.Cookie'], ($, Model, View, Collection, Cookie) ->

	i = 0

	class Toggle extends Model

		defaults:
			active: false

		initialize: ->
			new ToggleView model: @


	class ToggleView extends View

		initialize: ->
			@model.on 'change:active', @active, @
			@model.on 'create', @create, @
			@model.on 'showButton', @show, @
			@model.on 'hideButton', @hide, @

		create: (@$el) ->
			@model.set 'value': @$el.data('value')
			if @$el.find('.toggle').length
				@delegateEvents { 'click .toggle': @events['click'] }
			else
				@delegateEvents()
			@active @model, @model.get('active')

		active: (a, active) ->
			if active
				@$el.addClass('active')
				@$el.parent().addClass 'active-' + @model.get('i')
			else
				@$el.removeClass('active')
				@$el.parent().removeClass 'active-' + @model.get('i')

		show: () ->
			@$el.parents('.content').find('button').removeClass 'hidden'

		hide: () ->
			@$el.parents('.content').find('button').addClass 'hidden'

		events:
			'click': (e) ->
				e.preventDefault()
				@model.set active: true


	class ToggleCollection extends Collection

		model: Toggle

		initialize: ->
			this.on 'add', ->
				this.each (m, i) ->
					m.set i:i
			this.on 'change:active', =>
				if this.where({ active: true }).length > 0 then this.first().trigger 'showButton'
				else this.first().trigger 'hideButton'

		exclusive: ->
			this.on 'change:active', (m) =>
				if m.get('active') is true
					this.each (n) ->
						if m.cid isnt n.cid then n.set active: false

		active: ->
			active = this.findWhere active: true
			if active? then return active.get('value')



	Toggle.Collection = ToggleCollection

	return Toggle
