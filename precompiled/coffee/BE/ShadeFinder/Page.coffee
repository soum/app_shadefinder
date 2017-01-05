# -----------------------------------
#
# 	Page
# 
# -----------------------------------
define 'BE.Page', ['$','UI', 'BE.Models.Page', 'BE.Views.Page', 'BE.States', 'BE.Logic', 'BE.StaticStates'], ($, UI, Model, View, DynamicStates, logic, StaticStates) ->

	Cookie = UI.Cookie

	if UI.Browser.is.IE9() or UI.Browser.is.IE8() then states = StaticStates
	else states = DynamicStates

	class Page extends Model

		states: states

		initialize: ->
			new View model: @
			Cookie.sync @, 'state', 'page'
			super

	page = new Page

	logic.on 'navigate', (to) ->
		page.navigate to

	$ ->

		page.trigger 'create', $('main')


	return page