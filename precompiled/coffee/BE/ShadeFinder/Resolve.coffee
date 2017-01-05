# -----------------------------------
#
# 	Resolve
#
# -----------------------------------
define 'BE.Resolve', ['$', 'BE.Models.Resolve', 'BE.Views.Resolve', 'BE.Logic', 'BE.Products'], ($, Model, View, logic, products) ->

	class Resolve extends Model

		initialize: ->
			new View model: @
			super

	resolves = [
		new Resolve
		new Resolve
	]

	logic.on 'change:foundation change:products change:brush change:family', () ->
		result =
			foundation: logic.get 'foundation'
			products: logic.get 'products'
			brush: logic.get 'brush'
		for resolve in resolves
			resolve.set result: result, family: logic.get 'family'

	logic.on 'change:showing', () ->
		if logic.get('showing') is 1
			resolve.set productsVisible: false for resolve in resolves
		else
			resolve.set productsVisible: true for resolve in resolves

	products.on 'sync', ->
		for resolve in resolves
			resolve.trigger 'refresh', products

	addedBoth = ->
		# @currentCount = 0 if isNaN(@currentCount) # ben's attempt for making the two checkmarks work
		both = [false, false]
		brushes = logic.get 'brush'
		for foundation, i in logic.get 'foundation'
			# @currentCount += 1
			brush = products.findWhere id: brushes[i], added: true
			foundation = products.findWhere id: foundation, added: true
			if brush? or foundation?
				both[i] = true
		resolve.set addedBoth: both for resolve in resolves

	products.on 'change:added', addedBoth

	logic.on 'change:foundation', addedBoth

	addBoth = (match) ->
		b = logic.get('brush')[match]
		f = logic.get('foundation')[match]
		brush = products.findWhere id: b, added: false
		foundation = products.findWhere id: f, added: false
		if brush? then brush.addToCart(true)
		if foundation? then foundation.addToCart(true)

	for resolve in resolves
		resolve.on 'addBoth', addBoth

	$ ->

		resolves[0].trigger 'create', $('#Resolve')
		resolves[1].trigger 'create', $('#MobileResolve')



	return resolves
