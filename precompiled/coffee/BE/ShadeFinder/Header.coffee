# -----------------------------------
#
# 	Header
#
# -----------------------------------
define 'BE.Header', ['$', 'BE.Views.Header', 'BE.Page'], ($, Header, page) ->

	header = new Header model: page

	$ ->

		header.create $('header')

	return header
