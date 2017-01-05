# -----------------------------------
#
# 	Shadefinder > Video Modal
#
# -----------------------------------
define 'BE.VideoModal', ['$', 'BE.Models.VideoModal', 'BE.Views.VideoModal', 'BE.Page'], ($, Model, View, page) ->

	class VideoModal extends Model

		initialize: ->
			super
			new View model: @


	videoModal = new VideoModal duration: 400

	page.on 'video', (video) ->
		videoModal.set({ video: video }).trigger 'show'

	$ ->
		videoModal.trigger 'create', $ '#VideoModal'
		$('.video .thumbnail').on 'click', (e) ->
			e.preventDefault()
			video = $(e.target).parent().data('video')
			videoModal.set({ video: video }).trigger 'show'

	return videoModal
