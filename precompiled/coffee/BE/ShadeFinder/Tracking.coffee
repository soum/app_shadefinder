# -----------------------------------
#
# 	Tracking
#
# -----------------------------------
define 'BE.Tracking', ['$', 'Model', 'BE.Page', 'BE.Filters', 'BE.Products'], ($, Model, page, filters, products) ->

	iframed = ->
		try
			return window.self isnt window.top
		catch error
			return true

	class Tracking extends Model

		initialize: ->
			if window['cmSetClientID']?
				# @on 'click', @click
				@page()

		click: (eventID, categoryID) ->
			tlCreateConversionEventTag eventID, 2, categoryID, 10, ""

		page: ->
			if iframed()
				referrer = window.top.location.href.split('#')[0]
			else
				referrer = document.referrer
			#cmCreateManualPageviewTag Coremetrics.page, Coremetrics.category, window.location.href, referrer, null, null, null, null


	tracking = new Tracking

	track = 1

	watch = (el) ->
		el.on 'click', ->
			id = el.data('id')
			if id and id.indexOf('Track') > -1
				tracking.click id, 'Shade Finder - ' + el.data('category')
				track = el.data('value')
			else
				tracking.click el.data('value'), 'Shade Finder - Track ' + track + ' - ' + el.data('category')

	$ ->

		intro = $ '#Intro'

		intro.on 'click', '.start', (e) ->
			tracking.click $(e.target).data('id'), $(e.target).data('category')

		for key, filter of filters
			$(filter.el).each ->
				watch $(@)

		navigation = $ '#Navigation'

		navigation.on 'click', '.back', (e) ->
			tracking.click $(e.target).data('id'), 'Shade Finder - ' + $(e.target).data('category')

		navigation.on 'click', '.reset', (e) ->
			tracking.click $(e.target).data('id'), 'Shade Finder - ' + $(e.target).data('category')

		navigation.on 'click', '.close', (e) ->
			tracking.click $(e.target).data('id'), 'Shade Finder - ' + $(e.target).data('category')

		$('.side-menu .dot').on 'click', (e) ->
			tracking.click $(e.target).data('id'), 'Shade Finder - ' + $(e.target).data('category')

		trackSelector = $ '.section-1'

		shades = $ '#Shades'

		shades.on 'click', '.shade .toggle', (e) ->
			shade = $(e.currentTarget).parent().data('value')
			tracking.click shade[0].toUpperCase() + shade.substring(1), 'Shade Finder - Track ' + track + ' - ' + $(e.currentTarget).parent().data('category')

		shades.on 'click', '.undertone', (e) ->
			tracking.click $(e.currentTarget).data('value'), 'Shade Finder - Track ' + track + ' - ' + $(e.currentTarget).data('category')

		resolve = $ '#Resolve, #MobileResolve'

		resolve.on 'click', 'a, .learn-more', ->
			anchor = $ @
			if !anchor.hasClass('video') then tracking.click anchor.attr 'href'

		products.on 'cart', (id, both) ->
			if !both then tracking.click '#AddToCart-' + id

		resolve.on 'click', '.toggle-match', (e) ->
			tracking.click $(e.currentTarget).data('id'), 'Shade Finder - ' + $(e.currentTarget).data('category')

		resolve.on 'click', '.add-both', ->
			tracking.click '#AddBoth'

		videoModal = $ '#VideoModal'

		videoModal.on 'click', '.hide', (e) ->
			tracking.click $(e.currentTarget).data('id'), $(e.currentTarget).data('category')

		tipsModal = $ '#TipsModal'

		tipsModal.on 'click', '.thumbnail', (e) ->
			tracking.click $(e.currentTarget).parent().data('id'), $(e.currentTarget).parent().data('category')

		results = $ '.matches'

	return tracking
