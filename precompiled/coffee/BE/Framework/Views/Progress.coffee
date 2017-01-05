# -----------------------------------
#
# 	Progress Bar
#
# -----------------------------------
define 'BE.Views.Progress', ['View', 'UI.Browser'], (View, Browser) ->

	class Progress extends View

		initialize: ->
			@model.on 'create', @create, @
			if !Browser.is.touch()
				$('.progress').bind 'mouseenter', @hoverOn
			$('.progress').on 'click', @progressClick
			$('.dot').on 'click', @click
			$('.side-menu').bind 'mouseleave', @hoverOff
			$('.sidebar-label').on 'click', @sidebarClick

		create: (@$el) ->
			@delegateEvents()

		show: -> @$el.addClass('show')

		hide: -> @$el.removeClass('show')

		animateIn: =>
			setTimeout ->
				$('.sidebar').addClass('open')
				return
			, 1000

			@initialSidebarHide = setTimeout ->
				$('.sidebar').removeClass('open')
				return
			, 2500

		selections: (@selections) ->
			for selection in @selections
				@model.on 'change:' + selection, @selection, @

		pages: (@pages) ->
			@model.on 'change:page', @page, @

		selection: ->
			@$el.each (a, el) =>
				el = $ el
				el = el.parent()

				dotsTrackOne = el.find('.progress-0 .dot')
				dotsTrackTwo = el.find('.progress-1 .dot')
				dots = if @track is 2 then dotsTrackTwo else dotsTrackOne

				labelsTrackOne = el.find('.sidebar-0 .sidebar-label')
				labelsTrackTwo = el.find('.sidebar-1 .sidebar-label')
				labels = if @track is 2 then labelsTrackTwo else labelsTrackOne

				for selection, i in @selections
					if @model.get(selection)? && @model.get(selection).length
						if dots.eq(i + 1).hasClass 'terminal'
							dots.eq(i + 1).addClass 'current'
							dots.eq(i).removeClass 'current'
							labels.eq(i + 1).addClass 'current'
							labels.eq(i).removeClass 'current'
						dots.eq(i).addClass 'active'
						dots.eq(i + 1).removeClass 'disabled'
						labels.eq(i).addClass 'active'
						labels.eq(i + 1).removeClass 'disabled'
					else
						dots.eq(i).removeClass 'active'
						dots.eq(i + 1).addClass 'disabled'
						labels.eq(i).removeClass 'active'
						labels.eq(i + 1).addClass 'disabled'

		page: ->
			@$el.each (a, el) =>
				el = $ el
				el = el.parent()
				page = @model.get 'page'

				dotsTrackOne = el.find '.progress-0 .dot'
				dotsTrackTwo = el.find '.progress-1 .dot'
				dots = dotsTrackOne

				labelsTrackOne = el.find '.sidebar-0 .sidebar-label'
				labelsTrackTwo = el.find '.sidebar-1 .sidebar-label'
				labels = labelsTrackOne

				for p, i in @pages
					if @track == 2
						dots = dotsTrackTwo
						labels = labelsTrackTwo
					else
						dots = dotsTrackOne
						labels = labelsTrackOne
					if p < page
						dots.eq(i).addClass 'passed'
						labels.eq(i).addClass 'passed'
					if p == page
						dots.eq(i - 1).addClass 'current'
						labels.eq(i - 1).addClass 'current'
					else
						dots.eq(i - 1).removeClass 'current'
						labels.eq(i - 1).removeClass 'current'

		navigate: (anchor) ->
			if !anchor.hasClass('disabled')
				to = anchor.data 'to'
				if (Math.floor(to/100) - @model.get('page') is 1) or (to is 901 and @model.get('page') is 6)
					@model.trigger 'navigate'
				else
					@model.trigger 'navigate', anchor.data('to')
				if anchor.parents().find('.mobile-nav')
					$('.mobile-toggle').click()



		sidebarClick: (e) =>
			return if not @$el.hasClass 'show'
			$dotClasses = $(e.target).attr('class').toString().split(' ')
			dotClass = $.grep $dotClasses, (n, i) ->
				return n.indexOf('dot') >= 0
			$dot = $('.progress-' + (@track - 1) + ' .' + dotClass[0] )
			$dot.bind('click touchstart', @click)
			$dot.click()

		click: (e) =>
			el = $(e.target)
			e.preventDefault()
			return if not el.parent().hasClass('show') or el.hasClass('current')
			if ! el.hasClass('disabled') and ! el.hasClass('current')
				$('.current').removeClass('current')  # change to el.find
				el.toggleClass('current')
			anchor = $ e.target
			mobileNav = anchor.parents('.mobile-nav')
			if mobileNav.length
				$('.menu-open').addClass('menu-closed').removeClass('menu-open')
				mobileNav.removeClass 'visible'
				setTimeout =>
					@navigate anchor
					mobileNav.addClass 'hidden'
				, 400
			else
				@navigate anchor

		progressClick: (e) =>
			e.stopImmediatePropagation();
			if $(e.currentTarget).find('.toggle-open').hasClass('active') or $(e.target).hasClass('toggle-open')
				@hoverOn e
			else
				@hoverOff e

		hoverOn: (e) =>
			e.stopImmediatePropagation();
			$('.toggle-open').removeClass 'active'
			$('.toggle-close').addClass 'active'
			if $(e.currentTarget).hasClass 'progress-0'
				$('.sidebar-0').addClass 'open'
			else
				$('.sidebar-1').addClass 'open'

		hoverOff: (e) =>
			if @initialSidebarHide then clearTimeout(@initialSidebarHide)

			e.stopImmediatePropagation();
			$('.toggle-open').addClass 'active'
			$('.toggle-close').removeClass 'active'
			$('.open').removeClass 'open'
