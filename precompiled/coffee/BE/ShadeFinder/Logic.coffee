# -----------------------------------
#
# 	Logic
# 
# -----------------------------------
define 'BE.Logic', ['BE.Models.Logic', 'UI'], (Model, UI) ->

	Cookie = UI.Cookie

	class Logic extends Model

		initialize: ->
			super
			Cookie.sync @, 'shade undertone', 'logic'
			

	logic = new Logic

	return logic