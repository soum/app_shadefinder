# -----------------------------------
#
# 	Shades
#
# -----------------------------------
define 'BE.States', ->

	States = [
		# ----------------------------------------
		#
		# 	Intro > Section 0
		#
		{ id: 0, duration: 800, animation: 'fade-in', continue: true }
		{ id: 1, duration: 600, animation: 'down-in', continue: true, nav: 0 },
		{ id: 2, duration: 400, animation: 'fade-in', continue: true, nav: 0 },
		{ id: 3, duration: 800, continue: false, nav: 0 },
		# ----------------------------------------
		#
		# 	Section 1
		#
		{ id: 101, duration: 800, continue: false, nav: 0 },
		# ----------------------------------------
		#
		# 	Track 1 > Section 2a
		#
		{ id: 200, duration: 800, animation: 'left-out', continue: true, nav: 1 },
		{ id: 201, duration: 100, continue: true, nav: 1 },
		{ id: 202, duration: 100, continue: true, nav: 1 },
		{ id: 203, duration: 100, continue: true, nav: 1 },
		{ id: 204, duration: 100, continue: true, nav: 1 },
		{ id: 205, duration: 100, continue: true, nav: 1 },
		{ id: 206, duration: 100, continue: true, nav: 1 },
		{ id: 207, duration: 800, animation: 'fade-in', continue: false, nav: 1 },
		#
		# 	Section 2b
		#
		{ id: 300, duration: 100, continue: true, nav: 2 },
		{ id: 301, duration: 100, continue: true, nav: 2 },
		{ id: 302, duration: 100, continue: true, nav: 2 },
		{ id: 303, duration: 100, continue: true, nav: 2 },
		{ id: 304, duration: 800, continue: false, nav: 2 },
		#
		# 	Section 3
		#
		{ id: 401, duration: 400, continue: true, nav: 2 },
		{ id: 402, duration: 400, continue: true, nav: 2 },
		{ id: 403, duration: 400, continue: true, nav: 2 },
		{ id: 404, duration: 800, continue: false, nav: 2 },
		#
		# 	Section 4
		#
		{ id: 501, duration: 400, continue: true, nav: 2 },
		{ id: 502, duration: 200, continue: true, nav: 2 },
		{ id: 503, duration: 200, continue: true, nav: 2 },
		{ id: 504, duration: 200, continue: true, nav: 2 },
		{ id: 505, duration: 200, continue: true, nav: 2 },
		{ id: 506, duration: 400, continue: false, nav: 2 },
		#
		# 	Section 6 (Shade Selection)
		#
		{ id: 601, duration: 800, continue: false, nav: 2 },
		{ id: 602, duration: 800, continue: 901, nav: 2 },
		# ----------------------------------------
		#
		# 	Track 2 > Section 5
		#
		{ id: 700, duration: 800, continue: true, nav: 0 },
		{ id: 701, duration: 800, continue: false, nav: 1 }, # 2
		#
		# 	Section 6 (Shade Selection)
		#
		{ id: 801, duration: 800, continue: false, nav: 2 }, # 2
		{ id: 802, duration: 800, continue: 901, nav: 2 }, # 2
		# ----------------------------------------
		#
		# 	Resolution > Section 7
		#
		{ id: 901, duration: 800, continue: false, nav: 2 }
	]
