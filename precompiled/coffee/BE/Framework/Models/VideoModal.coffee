# -----------------------------------
#
# 	Shadefinder > Modal
# 
# -----------------------------------
define 'BE.Models.VideoModal', ['UI'], (UI) ->

	class VideoModal extends UI.Modal

		defaults: 
			state: 'hidden'
			duration: 600
			video: undefined
			baseUrl: ShadeFinder.urls.video