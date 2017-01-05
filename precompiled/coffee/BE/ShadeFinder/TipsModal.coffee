# -----------------------------------
#
# 	Shadefinder > Tips Modal
# 
# -----------------------------------
define 'BE.TipsModal', ['$', 'UI', 'View'], ($, UI, View) ->

	class TipsModalView extends View

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'change:state', @state, @

		create: (@$el) ->
			@delegateEvents()

		state: ->
			current = @model.get 'state'
			previous = @model.previous 'state'
			@$el.removeClass(previous).addClass(current)

		events: 
			'click .hide' : (e) ->
				e.preventDefault()
				@model.trigger 'hide'
			'click .overlay': (e) ->
				e.preventDefault()
				@model.trigger 'hide'


	class TipsModal extends UI.Modal

		initialize: ->
			super
			new TipsModalView model: @


	tipsModal = new TipsModal duration: 400


	$ ->

		tipsModal.trigger 'create', $ '#TipsModal'

		$('.show-tips').on 'click', (e) ->
			e.preventDefault()
			tipsModal.trigger 'show'


	return tipsModal

