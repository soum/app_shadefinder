# -----------------------------------
#
# 	UI > Middle
# 
# -----------------------------------
define 'UI.Middle', ['$', 'Model', 'View', 'UI.Browser'], ($, Model, View, Browser) ->

	class Middle extends Model

		defaults: 
			height: undefined
			outer: undefined
			
		initialize: ->
			new MiddleView model: @


	class MiddleView extends View

		initialize: ->
			Browser.on 'resize', Browser.debounce(@resize, 200), @
			@model.on 'change:height change:outer', @position, @
			@model.on 'create', @create, @

		create: (@$el) ->
			@parent = @$el.parent()
			@resize()

		resize: ->
			height = @$el.outerHeight()
			outer = @parent.outerHeight()
			@model.set 
				height: height
				outer: outer

		position: () ->
			top = (@model.get('outer') - @model.get('height'))/2 
			transform = Browser.transform 'top', parseInt(top) + 'px'
			@$el.css transform[0], transform[1]


	return Middle