# -----------------------------------
#
# 	Mobile Nav
# 
# -----------------------------------
define 'BE.MobileNav', ['$', 'BE.Views.MobileNav', 'BE.Page'], ($, MobileNav, page) ->

	mobilenav = new MobileNav model: page

	$ ->

		mobilenav.create $('.mobile-nav')


	return mobilenav