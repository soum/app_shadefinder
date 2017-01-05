# -----------------------------------
#
# 	Page
#
# -----------------------------------
define 'BE.Models.Page', ['$', 'Model'], ($, Model) ->

	class Page extends Model

		states: []

		defaults:
			state: 0
			nav: undefined
			page: undefined
			track: undefined
			transitioning: false
			menu: false
			animation: undefined

		initialize: ->
			if @get('state') < 100 then @set state: 0
			@stateIndex = []
			@stateIndex.push state.id for state in @states
			@on 'change:state', @transition
			@on 'change:animation', ->
				@trigger @get 'animation'

		transition: ->
			state = _.findWhere @states, id: @get('state')
			@set nav: state.nav, page: Math.floor(state.id/100)

			clearTimeout @timeout
			if state.duration > 0
				@timeout = setTimeout =>
					if state.continue then @navigate state.continue
				, state.duration
			else if state.continue then @navigate state.continue

		navigate: (state) ->
			if state is true or !state?
				index = _.indexOf @stateIndex, @get('state')
				state = @stateIndex[index + 1]
			@set state: state

		back: ->
			page = @get('page')
			if page is 7 then current = 1
			else if @get('track') is 1 and page is 9 then current = 6
			else current = page - 1
			state = _.find @states, (state) ->
				return Math.floor(state.id/100) is current and state.continue is false
			@navigate state.id
