# -----------------------------------
#
# 	Shades
#
# -----------------------------------
define 'BE.Collections.Shade', ['Collection'], (Collection) ->

	class Shades extends Collection

		initialize: ->
			@on 'renderAll', =>
				@$el.empty()

				# Make sure the order of families is preserved -- this is important when switching
				# between screens with 5-6 shades
				sortedModel = @sortBy (s) =>
					if s.attributes.id is 'fair'
						return 0
					if s.attributes.id is 'light'
						return 1
					if s.attributes.id is 'medium'
						return 2
					if s.attributes.id is 'tan'
						return 3
					if s.attributes.id is 'dark'
						return 4
					if s.attributes.id is 'deep'
						return 5

				_.each sortedModel, (m) =>
					m.trigger 'destroy create', @$el

				if @$el.find('.shade').length < 5
					@$el.addClass('shades-min')
				else
					@$el.removeClass('shades-min')

			@on 'change:active', (m) =>
				if m.get('active') is true
					this.each (n) ->
						if m.cid isnt n.cid then n.set active: false
					@trigger 'render', m

		create: (@$el) ->
			@on 'change:active', (m) =>
				activeShade = @findWhere { active: true }

				# if activeShade?.attributes.id is 'fair' or not activeShade
				# 	@$el.removeClass 'has-active'
				# else
				# 	@$el.addClass 'has-active'
				#
				# return
				#
				if @findWhere({ active: true })
					@$el.addClass('has-active')
				else
					@$el.removeClass('has-active')

		active: ->
			active = this.findWhere active: true
			if active? then return active.get('value')
