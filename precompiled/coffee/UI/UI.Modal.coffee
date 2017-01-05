# -----------------------------------
#
# 	UI > Modal
# 
# -----------------------------------
define 'UI.Modal', ['Model'], (Model) ->

	class Modal extends Model

		defaults: 
			state: 'hidden'
			duration: 600

		initialize: () -> 
			@timeouts = []
			@clear().on('show', @show).on('hide', @hide)

		clear: () ->
			for timeout in @timeouts
				clearTimeout timeout
			@timeouts = [];
			return @

		show: () ->
			if @get('state') is 'show' or @get('state') is 'shown' then return @
			@clear().set state: 'show' 
			@timeouts.push setTimeout () =>
				@set state: 'shown' 
			, @get 'duration'

		hide: () ->
			if @get('state') is 'hide' or @get('state') is 'hidden' then return
			@clear().set state: 'hide'
			@timeouts.push setTimeout () =>
				@set state: 'hidden' 
			, @get 'duration'