# -----------------------------------
#
# 	Shades
#
# -----------------------------------
define 'BE.Shades', ['$', 'UI', 'BE.Models.Shade', 'BE.Views.Shade', 'BE.Collections.Shade', 'BE.Logic', 'BE.Page'], ($, UI, Model, View, Collection, logic, page) ->
	Browser = UI.Browser

	class Shade extends Model

		initialize: ->
			new View model: @
			UI.Cookie.sync @, 'active undertone', 'shade' + @id
			super


	class Shades extends Collection

		model: Shade

		create: (@$el) ->
			super
			@on 'renderAll render refresh', @refresh
			@on 'change:innerHeight change:toggleHeight', Browser.debounce @refresh, 400

		refresh: ->
			height = 0
			@each (m) ->
				m.set top: height
				if m.get('active') then height += m.get 'innerHeight'
				else height += m.get 'toggleHeight'
			@$el.parent().height height


	shades = new Shades

	logic.on 'change:shades', () ->
		shadesLength = logic.get('shades').length

		# Apply special class for when we have 6 shades
		if shadesLength is 6
			$('#Shades').addClass('-six')
		else
			$('#Shades').removeClass('-six')

		shades.set(logic.get 'shades').trigger 'renderAll'
		active = shades.findWhere active: true
		if active
			shades.trigger 'change:active', active

	shades.on 'change:active', (m) ->
		active = shades.active()
		logic.set shade: active

	shades.on 'undertone', (undertone) ->
		logic.set undertone: undertone
		shades.trigger 'undertoned', undertone

	$ ->
		shades.create $ '#Shades'

		section = $ '.section-5'
		left = section.find '.left'
		right = section.find '.right'
		max = section.find('.container').css('max-width')
		if max? then max = parseFloat max.replace('px','') else max = 0

		ie8 = Browser.is.IE8()

		resize = (o) ->
			if o.width > max then l = left.outerWidth(true) + ((o.width - max)/2)
			else l = left.outerWidth(true)
			width = o.width - l
			if ie8 and width > 1205
				width = 1205
				l = left.outerWidth(true) + ((1601 - max)/2)
			# right.css width: width, left: l

		Browser.on 'resize', resize

		page.on 'change:page', () ->
			if page.get('page') is 6 or page.get('page') is 8
				Browser.on 'resize', resize
				resize({ width: $(window).width() })
			else
				Browser.off 'resize', resize

	return shades
