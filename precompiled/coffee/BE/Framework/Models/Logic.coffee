# -----------------------------------
#
# 	Logic
#
# -----------------------------------
define 'BE.Models.Logic', ['Model', 'Data'], (Model, Data) ->
	logic = Data.logic
	Foundation = Data.foundation
	Alternate = Data.alternate

	class Logic extends Model

		defaults:
			track: undefined
			# Inputs
			coverage: undefined
			finish: undefined
			concern: undefined
			skintype: undefined
			shade: undefined
			undertone: undefined
			# Results
			family: undefined
			brush: undefined
			products: undefined
			foundation: undefined
			# Other
			showing: 0


		initialize: ->
			@set brush: [], products: [], foundation: []
			@on 'change:coverage change:finish change:concern change:skintype', @match
			@on 'change:shade change:undertone change:family', @shade
			@on 'change:family', @shades
			@on 'change:brush change:products change:foundation', @ids
			@on 'change:family change:foundation', @brush

		clean: (val) ->
			if val? then return val.toLowerCase().replace /[^a-z]/g, ''

		match: ->
			coverage = @clean @get('coverage')
			finish = @clean @get('finish')
			concern = @clean @get('concern')
			skintype = @clean @get('skintype')
			if coverage? and finish? and skintype? and concern? and logic[coverage]? and logic[coverage][finish] and logic[coverage][finish][concern] and logic[coverage][finish][concern][skintype]
				@set logic[coverage][finish][concern][skintype]
			else
				@set brush: [], products: [], family: []

		shade: ->
			family = @get('family')
			shade = @clean @get('shade')
			undertone = @get('undertone')
			foundation = []
			if family? and shade? and undertone?
				fam = @clean family[0]
				if Foundation[fam] and Foundation[fam][shade] and Foundation[fam][shade][undertone]
					foundation.push Foundation[fam][shade][undertone]
					fam2 = @clean family[1]
					if Alternate[foundation[0]] and Alternate[foundation[0]][fam2]
						foundation.push Alternate[foundation[0]][fam2]
			@set foundation: foundation

		shades: ->
			family = @get('family')[0]
			shades = Foundation[@clean family]
			collection = []
			for key, shade of shades
				collection.push id: key, options: shade
			@set shades: collection

		brush: ->
			family = @get('family')[0]
			foundation = @get 'foundation'
			brush = @get 'brush'
			if family && foundation && foundation.length && brush && (!brush.length || @get('usingDefault'))
				if Data['defaults'][@clean(family)]
					@set _.extend { usingDefault: true }, Data['defaults'][@clean(family)]

		ids: ->
			ids = []
			for foundation in @get 'foundation'
				ids.push { type: ShadeFinder.text.productType.foundation, id: foundation }
			for brush in @get 'brush'
				ids.push { type: ShadeFinder.text.productType.brush, id: brush }
			for product in @get 'products'
				ids.push { type: ShadeFinder.text.productType.product, id: product }
			@set ids: ids
