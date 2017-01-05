# -----------------------------------
#
# 	Intro
#
# -----------------------------------
define 'BE.Intro', ['$', 'BE.Models.Intro', 'BE.Views.Intro', 'BE.Page', 'BE.Logic'], ($, Model, View, page, logic) ->

	class Intro extends Model

		initialize: ->
			new View model: @
			super

	intro = new Intro model: page

	page.on 'change:page', ->
		intro.set page: page.get 'page'
		logic.set page: page.get 'page'

	intro.on 'change:visible', ->
		if !intro.get('visible') and page.get('page') is 0
			page.set state: 101
		else if intro.get('visible') and page.get('page') is 1
			page.set state: 3

	$ ->

		intro.trigger 'create', $('#Intro')

		intro.trigger 'fade', $('.section-1 .background-inner')

		if page.get('state') >= 2 then intro.set position: -1


	return intro
