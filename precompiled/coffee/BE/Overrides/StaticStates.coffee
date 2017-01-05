# -----------------------------------
#
# 	Static States
#
# -----------------------------------
define 'BE.StaticStates', ->

	States = [
		# ----------------------------------------
		#
		# 	Intro > Section 0
		#
		{ id: 0, duration: 0, continue: true }
		{ id: 1, duration: 0, continue: true, nav: 0 },
		{ id: 2, duration: 0, continue: true, nav: 0 },
		{ id: 3, duration: 0, continue: false, nav: 0 }
		#
		# 	Section 1
		#
		{ id: 101, duration: 0, continue: false, nav: 0 }
		# ----------------------------------------
		#
		# 	Track 1 > Section 2a
		#
		{ id: 200, duration: 0, animation: 'left-out', continue: true, nav: 0 },
		{ id: 201, duration: 0, continue: true, nav: 1 },
		{ id: 202, duration: 0, continue: true, nav: 1 },
		{ id: 203, duration: 0, continue: true, nav: 1 },
		{ id: 204, duration: 0, continue: true, nav: 1 },
		{ id: 205, duration: 0, continue: true, nav: 1 },
		{ id: 206, duration: 0, continue: true, nav: 1 },
		{ id: 207, duration: 0, animation: 'fade-in', continue: false, nav: 1 },
		#
		# 	Section 2b
		#
		{ id: 300, duration: 0, continue: true, nav: 2 },
		{ id: 301, duration: 0, continue: true, nav: 2 },
		{ id: 302, duration: 0, continue: true, nav: 2 },
		{ id: 303, duration: 0, continue: true, nav: 2 },
		{ id: 304, duration: 0, continue: false, nav: 2 },
		#
		# 	Section 3
		#
		{ id: 401, duration: 0, continue: true, nav: 2 },
		{ id: 402, duration: 0, continue: true, nav: 2 },
		{ id: 403, duration: 0, continue: true, nav: 2 },
		{ id: 404, duration: 0, continue: false, nav: 2 },
		#
		# 	Section 4
		#
		{ id: 501, duration: 0, continue: true, nav: 2 },
		{ id: 502, duration: 0, continue: true, nav: 2 },
		{ id: 503, duration: 0, continue: true, nav: 2 },
		{ id: 504, duration: 0, continue: true, nav: 2 },
		{ id: 505, duration: 0, continue: true, nav: 2 },
		{ id: 506, duration: 0, continue: false, nav: 2 },
		#
		# 	Section 6 (Shade Selection)
		#
		{ id: 601, duration: 0, continue: false, nav: 2 },
		{ id: 602, duration: 0, continue: 901, nav: 2 },
		# ----------------------------------------		#
		# 	Track 2 > Section 5
		#
		{ id: 700, duration: 0, continue: true, nav: 0 },
		{ id: 701, duration: 0, continue: false, nav: 1 }, # 2
		#
		# 	Section 6 (Shade Selection)
		#
		{ id: 801, duration: 0, continue: false, nav: 2 }, # 2
		{ id: 802, duration: 0, continue: 901, nav: 2 }, # 2
		# ----------------------------------------
		#
		# 	Resolution > Section 7
		#
		{ id: 901, duration: 0, continue: false, nav: 2 }
	]
