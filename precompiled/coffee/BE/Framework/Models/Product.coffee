# -----------------------------------
#
# 	Product
#
# -----------------------------------
define 'BE.Models.Product', ['Model'], (Model) ->

	class Product extends Model

		defaults:
			id: undefined
			type: undefined
			name: undefined
			shortDescription: undefined
			longDescription: undefined
			pricing: undefined
			availability: undefined
			subtitle: undefined
			imageUrl: undefined
			thumbnailUrl: undefined
			url: undefined
			isAvailable: undefined
			video: undefined
			added: false
			master: false
			color: undefined
			foundation: undefined
			price: undefined
			addedToSidebar: false

		initialize: ->
			@refresh()

		refresh: ->
			name = @get 'name'
			if name then name = name.split(' - ')[0]
			else name = ''
			spfRegex = /broad spectrum spf (\d{0,3})/gi
			if name.match(spfRegex)
				spf = name.match(spfRegex)[0]
				foundation = name.replace(spfRegex, '')
				heading = '<span class="heading">' + name.replace(spfRegex, '') + '</span>'
				sub = '<span class="sub">' + spf + '</span> '
				name = heading + sub
				@set name: name, foundation: foundation
			else
				@set name: '<span class="heading">' + name + '</span>'
				@set foundation: name

		addToCart: (both) ->
			if !@get 'added' then @set({ added: true }).trigger 'cart', @id, both
