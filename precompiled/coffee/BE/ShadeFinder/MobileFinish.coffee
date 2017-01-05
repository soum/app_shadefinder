# -----------------------------------
#
# 	Mobile Finish
# 
# -----------------------------------
define 'BE.MobileFinish', ['$', 'BE.Models.MobileFinish', 'BE.Views.MobileFinish', 'BE.Page'], ($, Model, View, page) ->

	class MobileFinish extends Model

		initialize: ->
			new View model: @
			super

	mobilefinish = new MobileFinish

	page.on 'change:page', ->
		prev = page.previous 'page'
		next = page.get 'page'
		if prev is 3 and next is 4 then mobilefinish.trigger 'tutorial', 1200
		else if next is 4 then mobilefinish.trigger 'tutorial'

	$ ->

		mobilefinish.trigger 'create', $ '.section-3 .wrapper'