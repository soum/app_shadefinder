# -----------------------------------
#
# 	Progress Bar
#
# -----------------------------------
define 'BE.Progress', ['$', 'BE.Views.Progress', 'BE.Logic', 'BE.Page'], ($, View, logic, page) ->
	# create new subset of Progress for ProgressLabels


	progress = [
		new View model: logic
		new View model: logic
	]
	# add new View labels

	animatedIn = false

	progress[0].selections ['concern', 'skintype', 'finish', 'coverage', 'undertone']

	progress[0].pages [1,2,3,4,5,6,9]

	progress[0].track = 1

	progress[1].selections ['family', 'undertone']

	progress[1].pages [1,7,8,9]

	progress[1].track = 2

	page.on 'change:page', ->
		prev = page.previous 'page'
		next = page.get 'page'
		if !animatedIn
			if prev is 1 and next is 2 || prev is 1 and next is 7
				#progress.trigger 'animateIn', 2500
				progress[0].animateIn()
				animatedIn = true
			if prev is 1 and next is 7
				progress[1].animateIn()
				animatedIn = true

	track =  ->
		switch logic.get 'track'
			when 1
				progress[0].show()
				progress[1].hide()
				$('.sidebar-0').show()
				$('.sidebar-1').hide()

			when 2
				progress[1].show()
				progress[0].hide()
				$('.sidebar-1').show()
				$('.sidebar-0').hide()

	logic.on 'change:track', track

	$ ->

		progress[0].create $('.progress-0')

		progress[1].create $('.progress-1')


	return progress
