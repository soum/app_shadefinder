# -----------------------------------
#
# 	Shade Finder
# 
# -----------------------------------
# @codekit-prepend "../UI/UI.Animator.coffee"
# @codekit-prepend "../UI/UI.Browser.coffee"
# @codekit-prepend "../UI/UI.Middle.coffee"
# @codekit-prepend "../UI/UI.Toggle.coffee"
# @codekit-prepend "../UI/UI.coffee"
# @codekit-prepend "Framework/Models/Logic.coffee"
# @codekit-prepend "Framework/Models/Product.coffee"
# @codekit-prepend "Framework/Collections/Product.coffee"
# ------------------------------------
define '$', () -> return $
define 'Model', () -> return Backbone.Model
define 'View', () -> return Backbone.View
define 'Collection', () -> return Backbone.Collection

require ['$', 'UI', 'Model', 'View', 'Collection', 'Data', 'BE.Models.Logic', 'BE.Collections.Product'], ($, UI, Model, View, Collection, Data, LogicModel, ProductsCollection) ->

	# -----------------------------------
	#
	# 	Data
	# 
	# -----------------------------------
	Logic = Data.logic
	Foundation = Data.foundation

	# -----------------------------------
	#
	# 	Test
	# 
	# -----------------------------------
	class TestModel extends Model

		initialize: ->
			new TestView model: @

		test: (model) ->
			state = []
			success = []
			fail = []
			$('.track-1 input[name="coverage"]').each (i) ->
				state[0] = $(@).val()
				$(@).prop('checked', true).change()
				$('.track-1 input[name="finish"]').each (i) ->
					state[1] = $(@).val()
					$(@).prop('checked', true).change()
					$('.track-1 input[name="concern"]').each (i) ->
						state[2] = $(@).val()
						$(@).prop('checked', true).change()
						$('.track-1 input[name="skintype"]').each (i) ->
							state[3] = $(@).val()
							$(@).prop('checked', true).change()
							$('.track-1 input[name="shade"]').each (i) ->
								state[4] = $(@).val()
								$(@).prop('checked', true).change()
								$('.track-1 input[name="undertone"]').each (i) ->
									state[5] = $(@).val()
									$(@).prop('checked', true).change()
									if model.get('brush')? and model.get('products')? and model.get('foundation')?
										success.push state.join(' - ')
									else 
										fail.push state.join(' - ')
			@set success: success, fail: fail
			@trigger 'render'


	class TestView extends View 

		template: _.template '' +
			'<h2 class="green"><%= success.length %> Successful</h2>' +
			'<h2><%= fail.length %> Failed</h2>' +
			'<div class="failed">' +
				'<% _.each(fail, function(f) { %>' +
					'<p class="failed"><%= f %></p>' +
				'<% }); %>' +
			'</div>'

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'render', @render, @

		create: (@$el) ->

		render: ->
			@$el.find('.test-result').html @template @model.attributes


	# -----------------------------------
	#
	# 	Product/Products
	# 
	# -----------------------------------
	class Product extends Model

		defaults: 
			id: undefined
			title: undefined

		initialize: ->
			new ProductView model: @

	class ProductView extends View

		template: _.template '' + 
			'<p><%= title %> (<%= id %>)</p>'

		initialize: ->
			@model.on 'create', @create, @

		create: (container) ->
			container.append @template @model.attributes
			@$el = container.find('p').last()

	class Products extends Collection

		model: Product

		sync: (a,b,c) ->
			products = []
			for prod in @ids 
				if Data.products[prod.id]?
					product = Data.products[prod.id]
					products.push title: product, id: prod.id
			c.success(products)

		retrieve: (ids) ->
			@ids = ids
			@fetch()
			

	# -----------------------------------
	#
	# 	Undertones
	# 
	# -----------------------------------
	class UndertoneModel extends Model

		defaults: 
			undertone: undefined
			family: undefined
			shade: undefined
			undertones: undefined

		initialize: ->
			new UndertoneView model: @
			@on 'change:family change:shade', @undertones

		clean: (val) ->
			if val? then return val.toLowerCase().replace /[^a-z]/g, ''

		undertones: ->
			family = @clean @get 'family'
			shade = @clean @get 'shade'
			if Foundation[family] && Foundation[family][shade]
				undertones = Foundation[family][shade]
				@set undertones: undertones
			else @set undertones: []


	class UndertoneView extends View

		template: _.template '' +
			'<% _.each(undertones, function(u, key) { %>' +
				'<label><%= key %></label> ' +
				'<input type="radio" name="undertone" value="<%= key %>" <% if (undertone === key) print("checked"); %>>' +
			'<% }); %>'

		initialize: ->
			@model.on 'create', @create, @
			@model.on 'change:undertones', @render, @

		create: (@$el) ->
			@delegateEvents()

		render: ->
			@$el.html @template @model.attributes

		events: 
			'change input': (e) ->
				radio = $ e.currentTarget
				@model.set undertone: radio.val()



	# -----------------------------------
	#
	# 	Logic View
	# 
	# -----------------------------------
	class LogicView extends View

		template: _.template '' +
			'<% if (family && _.isArray(family) && family.length) { %>' + 
				'<h2>Family</h2>' +
				'<% _.each(family, function(f) { %>' +
					'<p><%= f %></p>' + 
				'<% }); %>' +
			'<% } else if (family && _.isString(family)) { %>' + 
				'<h2>Family</h2>' +
				'<p><%= family %></p>' + 
			'<% } %>' + 
			'<% if (brush && brush.length) { %>' + 
				'<h2>Brush</h2>' +
				'<% _.each(brush, function(f) { %>' +
					'<div data-id="<%= f %>"></div>' + 
				'<% }); %>' +
			'<% } %>' + 
			'<% if (products && products.length) { %>' + 
				'<h2>Cross sells</h2>' +
				'<% _.each(products, function(f) { %>' +
					'<div data-id="<%= f %>"></div>' + 
				'<% }); %>' +
			'<% } %>' +
			'<% if (foundation && foundation.length) { %>' + 
				'<h2>Foundation</h2>' +
				'<% _.each(foundation, function(f) { %>' +
					'<div data-id="<%= f %>"></div>' +
				'<% }); %>' +
			'<% } %>'


		initialize: ->
			@model.on 'create', @create, @

		create: (@$el) ->
			@delegateEvents()

		update: (products) ->
			@$el.find('.found').html @template @model.attributes
			products.each (p) =>
				p.trigger 'create', @$el.find('[data-id="' + p.get('id') + '"]')

		coverage: ->
			checked = @$el.find('input[name="coverage"]:checked')
			@model.set coverage: checked.val()

		finish: ->
			checked = @$el.find('input[name="finish"]:checked')
			@model.set finish: checked.val()

		concern: ->
			checked = @$el.find('input[name="concern"]:checked')
			@model.set concern: checked.val()

		skintype: ->
			checked = @$el.find('input[name="skintype"]:checked')
			@model.set skintype: checked.val()

		shade: ->
			checked = @$el.find('input[name="shade"]:checked')
			@model.set shade: checked.val()

		undertone: ->
			checked = @$el.find('input[name="undertone"]:checked')
			@model.set undertone: checked.val()

		family: ->
			checked = @$el.find('input[name="family"]:checked')
			@model.set family: [checked.val()]

		events: 
			'change input[name="coverage"]': 'coverage'
			'change input[name="finish"]': 'finish'
			'change input[name="concern"]': 'concern'
			'change input[name="skintype"]': 'skintype'
			'change input[name="shade"]': 'shade'
			'change input[name="undertone"]': 'undertone'
			'change input[name="family"]': 'family'
			'click .test': ->
				@model.trigger 'test', @model


	# -----------------------------------
	#
	# 	ProductsList
	# 
	# -----------------------------------
	class ProductListView extends View
		
		template: _.template '' +
			'<div class="product-view even-<%= even %>" data-id="<%= id %>">' +
				'<% if (isAvailable) { %>' +
					'<a class="product-image" target="_blank" href="<%=url %>">' + 
						'<% if (imageUrl) { %>' +
							'<img src="<%= imageUrl %>" />' + 
						'<% } %>' +
					'</a>' +
				'<% } else { %>' + 
					'<div class="product-image">' + 
						'<% if (imageUrl) { %>' +
							'<img src="<%= imageUrl %>" />' + 
						'<% } %>' +
					'</div>' +
				'<% } %>' +
				'<div class="product-content">' +
					'<% if (isAvailable) { %>' +
						'<a class="name" target="_blank" href="<%=url %>">' +
							'<%= name %>' +
							'<% if (color) { %>' +
								'<span class="color"><%= color %></span>' +
							'<% } %>' +
						'</a>' +
						'<% if (subtitle) { %>' +
							'<div class="subtitle"><%= subtitle %></div>' +
						'<% } %>' +
					'<% } else { %>' + 
						'<div class="name"><%= id %> is not available</div>' +
					'<% } %>' +
					'<% if (price) { %>' +
						'<div class="price"><%= price %></div>' +
					'<% } else { %>' +
						'<div class="price">N/A</div>' +
					'<% } %>' +
					'<% if (master) { %>' +
						'<button class="learn-more" href="<%=url %>">' + ShadeFinder.text.learnMore + '</button>' +
					'<% } else if (added) { %>' +
						'<button class="disabled" readonly>' + ShadeFinder.text.addedToBag + '</button>' +
					'<% } else if (isAvailable) { %>' +
						'<button class="add" data-id="<%= id %>">' + ShadeFinder.text.addToBag + '</button>' +
					'<% } else { %>' +
						'<button class="disabled" readonly>' + ShadeFinder.text.notAvailable  + '</button>' +
					'<% } %>' +
					'<% if (type === "foundation" && video) { %>' +
						'<a class="video" data-video="<%= video %>">' + ShadeFinder.text.watchVideo + '</a>' +
					'<% } %>' +
				'</div>' +
			'</div>'

		initialize: ->
			@model.on 'create', @create, @

		create: (container) ->
			container.append @template @model.attributes
			@$el = container.find('.product-view').last()



	productsList = new ProductsCollection

	allProducts = []
	for key, p of Data.products
		allProducts.push { id: key }

	i = 0
	productsList.on 'add', (m) ->
		m.set even: i++ % 2
		new ProductListView model: m
		m.trigger 'create', $ '#ProductList'

	# -----------------------------------
	#
	# 	Initialize
	# 
	# -----------------------------------
	finder = (container) ->

		model = new LogicModel

		view = new LogicView model: model

		products = new Products

		test = new TestModel

		undertones = new UndertoneModel

		model.on 'change:ids', ->
			products.retrieve model.get 'ids'

		products.on 'sync', (m) ->
			view.update products

		model.on 'test', () ->
			model.off 'change:ids'
			test.test model
			model.on 'change:ids', ->
				products.retrieve model.get 'ids'

		model.on 'change:family change:shade', () ->
			if model.get('family')
				if _.isArray(model.get('family')) then family = model.get('family') else family = [model.get('family')]
				undertones.set family: family[0], shade: model.get('shade')

		$ ->
			model.trigger 'create', $ container
			test.trigger 'create', $ container + ' .test'
			undertones.trigger 'create', $ container + ' .undertones'


	finder '.track-1'

	finder '.track-2'

	$ ->

		productsList.retrieve allProducts





