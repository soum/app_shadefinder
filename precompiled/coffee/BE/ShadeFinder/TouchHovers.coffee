# -----------------------------------
#
# 	Touch Hovers
# 
# -----------------------------------
define 'BE.TouchHovers', ['$', 'UI'], ($, UI) ->

	Drag = UI.Events.Drag

	bodyDrag = undefined

	add = (els) ->

		bodyDrag = bodyDrag or Drag $el: $(document), suffix: '.touchhoversbody', min: 0, preventable:false

		els.each ->

			el = $ @

			drag = Drag $el: el, suffix: '.touchhovers', min: 0, preventable:false

			drag.on 'start', ->
				bodyDrag.once 'end', ->
					el.removeClass 'hover'
				el.addClass 'hover'

	$ ->

		add $('button, a')

	return add: add
