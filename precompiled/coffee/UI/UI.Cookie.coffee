# -----------------------------------
#
# 	UI > Cookie
#
# -----------------------------------
define 'UI.Cookie', ['$', 'Model', 'View', 'Collection', 'UI.Browser'], ($, Model, View, Collection, Browser) ->

	class Cookie extends Model

		defaults:
			isNew: true
			name: undefined
			value: undefined
			type: undefined

		initialize: ->
			@clean()

		clean: ->
			value = @get 'value'
			if value is 'undefined'
				@collection.remove @set value: undefined
			else if value is 'true' or value is 'false'
				@set type: 'boolean', value: @get('value') is 'true'
			else if !isNaN(value)
				@set type: 'number', value: +value


	class Cookies extends Collection

		model: Cookie

		initialize: ->
			if window['localStorage']
				date = localStorage.getItem('UIdate')
				if date and new Date().toDateString() isnt new Date(date).toDateString()
					localStorage.removeItem('UI')
					localStorage.removeItem('UIdate')
				data = localStorage.getItem('UI')
				if data then for item in data.split(';')
					i = item.split(':')
					@add name: i[0], value: i[1]
				@on 'add change remove', Browser.debounce @save, 600

		select: (name) ->
			@findWhere name: name

		bind: (model, option, id) ->
			cookie = @select(id + option)
			if cookie
				o = {}
				o[option] = cookie.get 'value'
				model.set o
			else
				cookie = @add({ name: id + option, value: model.get(option) }).last()
			model.on 'change:' + option, ->
				cookie.set value: model.get option

		sync: (model, options, id) ->
			options = $.trim(options).replace(/\s+/, ' ').split(' ')
			@bind model, option, id for option in options

		save: () ->
			value = ''
			length = @length - 1
			@each (m, i) ->
				if i isnt length then bar = ';' else bar = ''
				value += m.get('name') + ':' + m.get('value') + bar
			localStorage.setItem 'UI', value
			localStorage.setItem 'UIdate', new Date().toString()


	new Cookies
