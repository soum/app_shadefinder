# -----------------------------------
#
# 	Products
#
# -----------------------------------
define 'BE.Products', ['$', 'UI', 'BE.Collections.Product', 'BE.Logic', 'BE.Cart', 'BE.Page'], ($, UI, Products, logic, cart, page) ->

	Browser = UI.Browser

	products = new Products

	logic.on 'change:ids', UI.Browser.debounce () ->
		products.retrieve logic.get 'ids'
	, 400

	testAdded = (m) ->
		if cart.has m.id then m.set added: true
		else m.set added: false

	cart.on 'change:products', () ->
		products.each testAdded

	products.on 'add', () ->
		products.each testAdded

	products.on 'cart', (ids) ->
		if !_.isArray(ids) then ids = [ids]
		cart.add ids

	$ ->


		if Browser.is.IE8() or Browser.is.IE9()

			loader = $('.loader').css({ visibility: 'visible', top: 0 }).hide()

			refresh = (loading) ->
				p = page.get('page')
				if loading and p is 9 then loader.show().stop().animate { opacity: 0.8 }, 400
				else loader.stop().animate { opacity: 0 }, 400, () ->
					loader.hide()

			products.on 'changeLoading', refresh


		else

			html = $ 'html'
			timeout = undefined

			products.on 'changeLoading', (loading) ->
				clearTimeout timeout
				if loading then html.addClass 'load loading'
				else
					html.removeClass 'loading'
					timeout = setTimeout ->
						html.removeClass 'load'
					, 400

	return products
