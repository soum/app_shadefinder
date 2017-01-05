# -----------------------------------
#
# 	Mobile Finish
# 
# -----------------------------------
define 'BE.Models.MobileFinish', ['Model', 'UI'], (Model, UI) ->

	Animate = UI.Animate

	class MobileFinish extends Model

		defaults: 
			state: 1
			position: 1
			tutoring: false

		initialize: ->
			@on 'change:state', @animate
			@on 'tutorial', @tutorial
			@tutored = sessionStorage.getItem 'tutored'
			
		stop: ->
			if @animation? then @animation.stop()

		animate: ->
			@stop()
			prev = @previous 'state'
			next = @get 'state'
			@animation = Animate prev, next, 400, 'swing', (position) =>
				@set position: position

		prev: ->
			state = @get 'state'
			if state > 0 and @tutored then @set state: state - 1

		next: ->
			state = @get 'state'
			if state < 2 and @tutored then @set state: state + 1

		tutor: ->
			Animate 1, 1.5, 800, 'swing', (position) =>
				@set position: position
			, =>
				Animate 1.5, 0.5, 1200, 'swing', (position) =>
					@set position: position
				, =>
					Animate 0.5, 1, 800, 'swing', (position) =>
						@set position: position
					,=>
						@set tutoring: false

		tutorial: (duration) ->
			if !@tutored
				@tutored = true
				sessionStorage.setItem 'tutored', true
				setTimeout =>
					@set tutoring: true
					setTimeout =>
						@tutor()
					, 800
				, duration || 1200



