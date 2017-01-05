# -----------------------------------
#
# 	Cart
#
# -----------------------------------
define 'BE.Models.Cart', ['Model'], (Model) ->

	class Cart extends Model

		url: ShadeFinder.urls.cart

		addUrl: ShadeFinder.urls.addToCart

		defaults:
			products: []
			subtotal: 0
			numItems: 0

		initialize: ->
			@fetch()

		has: (id) ->
			found = false
			id = ShadeFinder.prefix + id
			for product in @get 'products'
				if product.id is id then found = true
			return found

		add: (ids) ->
			id = ShadeFinder.prefix + ids.join '_' + ShadeFinder.prefix
			xhr = $.ajax
				type: 'POST'
				url: @addUrl + id
				data:
					Quantity: 1
					uuid: ''
					cartAction: 'update'
					pid: id
			xhr.done (d) =>
				@trigger 'added', id
				# @trigger 'addToProgress'

				@fetch success: () =>
					@trigger 'change:products', @, @get 'products'


			xhr.fail () =>
				@trigger 'failed', id
