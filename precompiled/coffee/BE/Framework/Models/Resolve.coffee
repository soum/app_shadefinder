# -----------------------------------
#
# 	Resolve
#
# -----------------------------------
define 'BE.Models.Resolve', ['$', 'Model'], ($, Model) ->

	class Resolve extends Model

		defaults:
			result: {}
			foundation: []
			brushes: []
			products: []
			family: []
			hasProducts: false
			productsVisible: true
			hasSecondary: false

		initialize: ->
			@on 'refresh', @refresh
			@on 'change:products', @products
			@on 'change:brushes change:foundation', @matches
			@on 'change:brushes change:foundation', @both
			@on 'change:family', @family

		refresh: (products) ->
			result = @get 'result'
			foundation = []
			for id, i in result.foundation
				model = products.findWhere id: id
				if model
					foundation.push model
			brushes = []
			for id, i in result.brush
				model = products.findWhere id: id
				if model
					brushes.push model
			ps = []
			for id, i in result.products
				model = products.findWhere id: id
				if model
					ps.push model
			@set foundation: foundation, brushes: brushes, products: ps
			@trigger 'render'

		matches: ->
			brushes = @get 'brushes'
			foundation = @get 'foundation'
			if (brushes.length + foundation.length) is 4 then @set hasSecondary: true
			else @set hasSecondary: false

		both: ->
			brushes = @get 'brushes'
			foundation = @get 'foundation'
			both = []
			for brush, i in brushes
				if brush.get('isAvailable') and foundation[i] and foundation[i].get('isAvailable')
					both.push true
				else
					both.push false
			@set both: both

		products: ->
			products = @get 'products'
			if products.length then @set hasProducts: true
			else @set hasProducts: false

		family: ->
			familyTitles = []
			for family in @get 'family'
				if family then familyTitles.push ShadeFinder.text.family[family.toLowerCase()]
