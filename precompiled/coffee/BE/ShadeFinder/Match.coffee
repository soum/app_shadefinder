# -----------------------------------
#
# 	Match
# 
# -----------------------------------
define 'BE.Match', ['$', 'BE.Views.Match', 'BE.Logic'], ($, View, logic) ->

	match = new View model: logic

	$ ->

		win = $ window

		match.create $('#Match, #MobileMatch')

		scroller = $ '.section-8'

		logic.on 'change:showing', () ->
			if win.width() < 769 
				scroller.scrollTop 0
				setTimeout ->
					scroller.scrollTop 0
					setTimeout ->
						scroller.scrollTop 0
					, 30
				, 0



	return match
