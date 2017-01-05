# -----------------------------------
#
# 	Shade
#
# -----------------------------------
define 'BE.Models.Shade', ['Model'], (Model) ->

	class Shade extends Model

		defaults:
			id: undefined
			active: undefined
			value: undefined
			undertone: undefined
			family: undefined

		initialize: ->
			@set value: @id
