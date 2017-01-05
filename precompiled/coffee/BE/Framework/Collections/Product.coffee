# -----------------------------------
#
# 	Product
#
# -----------------------------------
define 'BE.Collections.Product', ['Model', 'Collection', 'BE.Models.Product', 'Data'], (Model, Collection, Product, Data) ->

	prefix = ShadeFinder.prefix

	url = ShadeFinder.urls.products

	missing =
		name: ShadeFinder.text.notFound
		isAvailable: false

	loader = new Model

	class Products extends Collection

		model: Product

		initialize: ->
			@requests = []
			loader.on 'change:loading', () =>
				@trigger 'changeLoading', loader.get 'loading'

		abort: ->
			for request in @requests
				request.abort()
			@requests = []

		sync: (a,b,c) ->
			products = []
			for id in @ids
				if Data.products[id]?
					product = Data.products[id]
					products.push title: product, id: id
			c.success(products)

		sync: (a, b, c) ->
			loader.set loading: true
			@abort()
			products = []
			remaining = @ids.length
			add = (p) =>
				products.push p
				if --remaining is 0
					@add(products).trigger 'sync'
					loader.set loading: false
			retrieve = (product) =>
				exists = @findWhere({ id: product.id })
				if exists then return add exists
				request = $.getJSON url + prefix + product.id, (data) =>
					add _.extend product, data
				request.fail ->
					add _.extend product, missing
				@requests.push request
			retrieve id for id in @ids

		retrieve: (ids) ->
			@ids = ids
			@fetch()