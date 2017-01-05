# -----------------------------------
#
# 	Match
# 
# -----------------------------------
define 'BE.Views.Match', ['View'], (View) ->

	class Match extends View

		initialize: ->
			@model.on 'change:showing', @showing, @

		create: (@$el) ->
			@delegateEvents()

		showing: ->
			showing = @model.get 'showing'
			@$el.removeClass('showing-0 showing-1').addClass('showing-' + showing);

		events: 
			'click .toggle-match': (e) ->
				e.preventDefault()
				if @model.get('showing') is 0 then showing = 1 else showing = 0
				@model.set showing: showing