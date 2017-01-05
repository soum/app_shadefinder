# -----------------------------------
#
# 	Filters
#
# -----------------------------------
define 'BE.Filters', ['$', 'UI', 'BE.Logic', 'BE.Page', 'BE.TouchHovers'], ($, UI, logic, page, hovers) ->

	i = 0

	class Filter extends UI.Toggle

		initialize: ->
			super
			key = @get 'key'
			UI.Cookie.sync @, 'active', key + 'toggle' + i++


	class FilterCollection extends UI.Toggle.Collection

		model: Filter


	filters =
		track: el: '.track'
		coverage: el: '.coverage'
		finish: el: '.glow'
		concern: el: '.concerns .icon'
		skintype: el: '.types .icon'
		family: el: '.family'

	collect = (key, filter) ->
		filter.collection = new FilterCollection().exclusive().on 'change:active', ->
			o = {}
			o[key] = @active()
			if key is 'family' then o[key] = [o[key]]
			logic.set o
			if key is 'track' then page.set o

	collect key, filter for key, filter of filters

	$ ->

		track = 1

		for key, filter of filters
			hovers.add $(filter.el)
			$(filter.el).each ->
				el = $ @
				f = filter.collection.add({ key: key }).last().trigger 'create', el
				if key is 'track' and f.get('active') then track = f.get('value')
				if track is 2
					if (key is 'family' or key is 'track') and f.get('active') then f.trigger 'change:active', f, f.get('active')
				else
					if key isnt 'family' and f.get('active') then f.trigger 'change:active', f, f.get('active')

	return filters
