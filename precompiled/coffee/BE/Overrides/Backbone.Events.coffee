# -----------------------------------
#
# 	Static States
#
# -----------------------------------
define 'Backbone.Events', ['View', 'UI'], (View, UI) ->

	Events = UI.Events

	View.prototype.events = {}

	View.prototype.delegateEventSplitter = /^(\S+)\s*(.*)$/

	View.prototype.delegateEvents =  (events) ->
		@undelegateEvents()
		@unlisten = []
		events = events or @events
		delegate = (key, method) =>
			match = key.match(@delegateEventSplitter)
			eventName = match[1]
			selector = match[2]
			if selector is '' then selector = null
			if typeof method is 'string' then method = @[method]
			if Events[eventName]
				Events[eventName].call @, '.delegateEvents' + @cid, selector, () =>
					method.apply @, arguments
			else
				@$el.on eventName + '.delegateEvents' + @cid, selector, () =>
					method.apply @, arguments
		delegate k,v for k,v of events
		return @

	View.prototype.undelegateEvents = () -> 
		@$el and @$el.off '.delegateEvents' + @cid
		if @unlisten
			for remove in @unlisten
				remove()
		return @
