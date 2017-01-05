# -----------------------------------
#
# 	Cart
#
# -----------------------------------
define 'BE.Cart', ['$','BE.Models.Cart'], ($, Cart) ->

	cart = new Cart

	$ ->

		$(window).focus ->
			cart.fetch({
				success: ->
					# console.log cart.get 'products'
			})

	return cart
