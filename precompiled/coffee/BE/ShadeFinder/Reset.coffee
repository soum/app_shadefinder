# -----------------------------------
#
# 	Reset
# 
# -----------------------------------
define 'BE.Reset', ['$', 'BE.Page', 'BE.Logic', 'BE.Filters', 'BE.Shades', 'BE.Resolve', 'BE.Products'], ($, page, logic, filters, shades, resolves, products) ->

	Reset =  ->

		products.each (m) ->
			m.trigger 'destroy'

		shades.each (m) ->
			m.set active: false

		for key, filter of filters
			filter.collection.each (m) ->
				if m.get('key') isnt 'track' then m.set active: false

		logic.set brush: [], products: [], foundation: [], family: [], undertone: undefined, showing: 0, usingDefault: false

		for resolve in resolves
			resolve.trigger 'reset'

		scrollers = $('.scrollable').scrollTop 0
		setTimeout ->
			scrollers.scrollTop 0
		, 0 


	page.on 'loaded', () ->

		page.on 'reset', ->
			setTimeout Reset, 800

		logic.on 'change:track', ->
			Reset()


	return Reset





