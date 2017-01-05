# -----------------------------------
#
# 	Product
#
# -----------------------------------
define 'BE.Views.Product', ['View', 'BE.Cart'], (View, cart) ->

	class ProductView extends View

		template: _.template '' +
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
			'<% } %>'


		titleTemplate: _.template '' +
			'<% if (isAvailable) { %>' +
				'<a class="name" target="_blank" href="<%=url %>">' +
					'<%= name %>' +
					'<% if (color) { %>' +
						'<span class="color"><%= color %></span>' +
					'<% } %>' +
				'</a>' +
			'<% } else { %>' +
				'<div class="name"><%= name %></div>' +
			'<% } %>'


		descriptionTemplate: _.template '' +
			'<% if (subtitle) { %>' +
				'<div class="subtitle"><%= subtitle %></div>' +
			'<% } %>' +
			'<% if (type === "foundation" && video) { %>' +
				'<a class="video" data-video="<%= video %>">' + ShadeFinder.text.watchVideo + ' <%= foundation %> ' + ShadeFinder.text.watchVideo2 + '</a>' +
			'<% } %>'

		buttonTemplate: _.template '' +
			'<% if (price) { %>' +
				'<div class="price"><%= price %></div>' +
			'<% } %>' +
			'<% if (master) { %>' +
				'<button class="learn-more" href="<%=url %>">' + ShadeFinder.text.learnMore + '</button>' +
			'<% } else if (added) { %>' +
				'<button class="disabled" readonly>' + ShadeFinder.text.addedToBag + '</button>' +
			'<% } else if (isAvailable) { %>' +
				'<button class="add" data-id="<%= id %>">' + ShadeFinder.text.addToBag + '</button>' +
			'<% } else { %>' +
				'<button class="disabled" readonly>' + ShadeFinder.text.notAvailable  + '</button>' +
			'<% } %>'

		teaser: _.template '' +
			'<div class="teaser-wrap <% if (thumbnailUrl) print("has-image"); %>">' +
				'<% if (thumbnailUrl) { %>' +
					'<div class="teaser-image">' +
						'<img src="<%= thumbnailUrl %>" />' +
					'</div>' +
				'<% } %>' +
				'<% if (foundation) { %>' +
					'<p class="teaser-message"><span><%= prelude %></span> <%= foundation %></p>' +
				'<% } else { %>' +
					'<p class="teaser-message"><span><%= prelude %></span> ' + ShadeFinder.text.notFound.toLowerCase() + '</p>' +
				'<% } %>' +
			'</div>'

		sidebarTemplate: _.template '' +
			'<div class="item just-added">' +
				'<% if (name) { %>' +
					'<p class="item-name"><%= type %></p>' +
				'<% } %>' +
				'<% if (price) { %>' +
					'<p class="item-price"><%= price %></p>' +
				'<% } %>' +
			'</div>'

		initialize: ->
			@model.on 'change:added', @added, @
			@model.on 'destroy', @destroy, @

		create: (@$el) ->
			@$el.not('.button').not('.description').not('.title').html @template @model.attributes
			@$el.not('.content').not('.description').not('.button').html @titleTemplate @model.attributes
			@$el.not('.button').not('.content').not('.title').html @descriptionTemplate @model.attributes
			@$el.not('.content').not('.description').not('.title').html @buttonTemplate @model.attributes
			@delegateEvents()

		tease: (container, i) ->
			if i is 1 then prelude = ShadeFinder.text.youMightAlso else prelude = ShadeFinder.text.returnToOur
			attrs = _.extend { prelude: prelude }, @model.attributes
			container.html @teaser attrs

		destroy: ->
			@model.off 'create', @create
			@model.off 'change:added', @added
			@model.off 'destroy', @destroy
			@model.off 'tease', @tease
			@undelegateEvents()

		added: ->
			@$el.not('.content').not('.description').not('.title').html @buttonTemplate @model.attributes
			if !@model.get('addedToSidebar') and !cart.has @model.id
				$('.item').removeClass 'just-added'
				cart.set 'subtotal' : cart.get('subtotal') + @model.get('pricing').sale
				if ShadeFinder.text.currencyPlacement is 'before'
					$('.subtotal .item-price').html ShadeFinder.text.currency + cart.get('subtotal').toFixed(2)
				else
					$('.subtotal .item-price').html cart.get('subtotal').toFixed(2) + ' ' + ShadeFinder.text.currency
				$('.cart-items').append @sidebarTemplate @model.attributes
				$('.sidebar-cart').show();
				$('.sidebar').addClass 'open'
				$('.toggle-close').addClass 'active'
				$('.toggle-open').removeClass 'active'
				setTimeout ->
					$('.sidebar').removeClass 'open'
					$('.toggle-close').removeClass 'active'
					$('.toggle-open').addClass 'active'
				, 2000
				@model.set addedToSidebar: true
				cart.set numItems: cart.get('numItems') + 1

				minicartItems = $('.sidebar-cart').find('.cart-items').find('.item:visible')
				minicartLength = 3
				$('.sidebar-cart .more-items .item-count').text(cart.attributes.numItems)

				i = minicartItems.length - minicartLength
				while i > 0
					$('.sidebar-cart').each ->
						$extraItem = $($(this).find('.item')[i-1])
						$extraItem.slideUp 400, =>
						    $extraItem.remove()
							return
					i--

		events:
			'click .add': (e) ->
				e.preventDefault()
				@model.addToCart()
			'click .learn-more': (e) ->
				e.preventDefault()
				href = $(e.currentTarget).attr 'href'
				if href then window.open(href, '_blank')
