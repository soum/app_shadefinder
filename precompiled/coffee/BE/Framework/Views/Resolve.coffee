# -----------------------------------
#
# 	Resolve
#
# -----------------------------------
define 'BE.Views.Resolve', ['$', 'UI', 'View', 'BE.Views.Product'], ($, UI, View, ProductView) ->

	Browser = UI.Browser

	class ResolveView extends View

		_addBoth: _.template '' +
			'<div class="price">&nbsp;</div>' +
			'<button class="add-both">' + ShadeFinder.text.addBoth + '</button>'

		_addedBoth: _.template '' +
			'<div class="price">&nbsp;</div>' +
			'<button class="disabled" readonly>' + ShadeFinder.text.addBoth + '</button>'

		initialize: ->
			Browser.on 'resize', @resize, @
			@model.on 'create', @create, @
			@model.on 'render', @foundation, @
			@model.on 'render', @brushes, @
			@model.on 'render', @products, @
			@model.on 'change:hasProducts change:productsVisible', @hasProducts, @
			@model.on 'change:hasSecondary', @hasSecondary, @
			@model.on 'change:both', @both, @
			@model.on 'change:addedBoth', @addedBoth, @
			@model.on 'reset', @reset, @

		create: (@$el) ->
			@delegateEvents()

		resize: (o) ->
			minHeight = 0
			matches = @$el.find('.match')
			matches.each ->
				height = $(@).find('.match-inner').height()
				if height > minHeight then minHeight = height
			matches.eq(0).css 'min-height', minHeight

		foundation: ->
			for foundation, i in @model.get 'foundation'
				if i is 0 then j = 1 else if i is 1 then j = 0
				new ProductView({ model: foundation }).create(@$el.find('.match').eq(i).find('.foundation')).tease @$el.find('.teaser').eq(j), i
				Browser.resize()

		brushes: ->
			for brush, i in @model.get 'brushes'
				new ProductView({ model: brush }).create @$el.find('.match').eq(i).find('.brush')
			Browser.resize()

		products: ->
			for product, i in @model.get 'products'
				new ProductView({ model: product }).create @$el.find('.product-' + i)
			Browser.resize()

		hasProducts: ->
			hasProducts = @model.get 'hasProducts'
			productsVisible = @model.get 'productsVisible'
			if hasProducts and productsVisible then @$el.find('.cross-sells').removeClass('hidden')
			else @$el.find('.cross-sells').addClass('hidden')

		hasSecondary: ->
			hasSecondary = @model.get 'hasSecondary'
			if hasSecondary then @$el.find('.match.second, .toggle-match').removeClass('hidden')
			else @$el.find('.match.second, .toggle-match').addClass('hidden')

		both: ->
			both = @model.get 'both'
			for available, i in both
				if available then @$el.find('.match').eq(i).find('.both').removeClass('hidden')
				else @$el.find('.match').eq(i).find('.both').addClass('hidden')

		addedBoth: ->
			matches = @$el.find('.match')
			both = @model.get 'addedBoth'
			for isAdded, i in both
				if isAdded then matches.eq(i).find('.both.button').html @_addedBoth()
				else matches.eq(i).find('.both.button').html @_addBoth()

		reset: ->
			@$el.find('.foundation, .brush, .cross-sell').each ->
				$(@).html('&nbsp;')

		events:
			'click .add-both': (e) ->
				match = $(e.currentTarget).parents('.match')
				if match.hasClass 'first' then @model.trigger 'addBoth', 0
				else if match.hasClass 'second' then @model.trigger 'addBoth', 1
