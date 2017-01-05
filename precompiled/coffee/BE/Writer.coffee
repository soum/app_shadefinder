# -----------------------------------
#
# 	Writer
# 
# -----------------------------------
# @codekit-prepend "../UI/UI.Browser.coffee"
# @codekit-prepend "../UI/UI.Middle.coffee"
# @codekit-prepend "../UI/UI.Toggle.coffee"
# @codekit-prepend "../UI/UI.Animator.coffee"
# @codekit-prepend "../UI/UI.coffee"
# ------------------------------------
requirejs.config baseUrl: '../../Content/Scripts'
shim:
    'slick':
      deps: [ 'jquery' ]
      exports: 'jQuery.fn.slick'

define '$', () -> return $
define 'Model', () -> return Backbone.Model
define 'View', () -> return Backbone.View
define 'Collection', () -> return Backbone.Collection

require ['$', 'UI', 'Libraries/paths-js/dist/amd/path'], ($, UI, Path) ->

	Animate = UI.Animate

	svg = document.querySelector('svg')
	path = document.querySelector('path')
	path.setAttribute('stroke', 'pink')
	path.setAttribute('fill', 'pink')
	path.setAttribute('stroke-width', 0.5)
	circle = document.createElementNS("http://www.w3.org/2000/svg", "circle")
	circle.setAttribute("r",  1)
	circle.setAttribute("fill", "transparent")
	svg.appendChild(circle)
	circle1 = document.createElementNS("http://www.w3.org/2000/svg", "circle")
	circle1.setAttribute("r",  1)
	circle1.setAttribute("fill", "transparent")
	svg.appendChild(circle1)

	bezier = (p) ->
		cx = 3 * (p[1][0] - p[0][0])
		bx = 3 * (p[2][0] - p[1][0]) - cx
		ax = p[3][0] - p[0][0] - cx - bx
		cy = 3 * (p[1][1] - p[0][1])
		_by = 3 * (p[2][1] - p[1][1]) - cy
		ay = p[3][1] - p[0][1] - cy - _by
		x = (t) -> return (ax * t * t * t) + (bx * t * t) + (cx * t) + p[0][0] 
		y = (t) -> return (ay * t * t * t) + (_by * t * t) + (cy * t) + p[0][1] 
		cp0x = (t) -> p[0][0] + (p[1][0] - p[0][0]) * t
		cp0y = (t) -> p[0][1] + (p[1][1] - p[0][1]) * t
		cp1x = (t) -> p[0][0] + (p[2][0] - p[0][0]) * t
		cp1y = (t) -> p[0][1] + (p[2][1] - p[0][1]) * t
		length = ->
			distance = 0
			for i in [0..99]
				distance += Math.abs(x((i + 1)/100) - x(i/100))
				distance += Math.abs(y((i + 1)/100) - y(i/100))
			return distance
		return {
			start: p[0]
			cp0: p[1]
			cp1: p[2]
			x: x 
			y: y
			cp0x: cp0x
			cp0y: cp0y
			cp1x: cp1x
			cp1y: cp1y
			length: length()
		}

	points = [
		[[297.912, 71.916], [299.055, 71.916], [299.627, 72.837], [299.627, 74.678]],
		[[299.627, 74.678], [299.627, 75.487], [298.727, 77], [296.928, 79.217]],
		[[296.928, 79.217], [295.129, 81.434], [293.825, 82.543], [293.017, 82.543]],
		[[293.017, 82.543], [292.152, 82.543], [291.733, 82.139], [291.762, 81.331]],
		[[291.762, 81.331], [291.762, 80.94], [291.957, 80.55], [292.348, 80.159]],
		[[292.348, 80.159], [292.989, 79.657], [293.617, 78.597], [294.231, 76.979]],
		[[294.231, 76.979], [294.733, 75.836], [295.227, 74.706], [295.715, 73.59]],
		[[295.715, 73.59], [295.227 + 2 * (295.715 - 295.227),  74.706 + 2 * (73.59 - 74.706)], [296.936, 71.916], [297.912, 71.916]]
	]

	points = [[[292.598,58.74],[292.207,58.74],[291.873,58.907],[291.594,59.238]],[[291.594,59.238],[291.594,59.238],[291.427,59.403],[291.427,59.403]],[[291.427,59.403],[289.865,61.257],[288.318,63.095],[286.783,64.918]],[[286.783,64.918],[284.887,67.073],[283.116,68.718],[281.47,69.852]],[[281.47,69.852],[278.57,71.734],[276.491,72.672],[275.238,72.672]],[[275.238,72.672],[274.373,72.672],[273.94,72.299],[273.94,71.553]],[[273.94,71.553],[273.94,70.423],[275.056,67.969],[277.287,64.186]],[[277.287,64.186],[277.455,63.882],[278.543,62.432],[280.551,59.828]],[[280.551,59.828],[282.141,57.708],[282.936,56.37],[282.936,55.811]],[[282.936,55.811],[282.936,54.724],[282.114,54.18],[280.467,54.18]],[[280.467,54.18],[280.049,54.18],[279.324,54.612],[278.291,55.477]],[[278.291,55.477],[276.646,56.844],[274.484,57.582],[271.808,57.694]],[[271.808,57.694],[271.975,57.304],[272.059,56.928],[272.059,56.565]],[[272.059,56.565],[272.059,55.561],[271.515,55.059],[270.427,55.059]],[[270.427,55.059],[270.399,55.059],[270.371,55.059],[270.343,55.059]],[[270.343,55.059],[268.753,55.059],[267.958,55.966],[267.958,57.778]],[[267.958,57.778],[267.958,58.364],[268.175,59.054],[268.61,59.849]],[[268.61,59.849],[268.683,59.985],[268.788,60.041],[268.868,60.152]],[[268.868,60.152],[266.612,63.123],[263.6,65.978],[259.634,68.686]],[[259.634,68.686],[255.06,71.869],[251.057,73.602],[247.627,73.884]],[[247.627,73.884],[247.236,73.884],[247.041,73.689],[247.041,73.292]],[[247.041,73.292],[247.041,72.25],[247.613,70.517],[248.756,68.094]],[[248.756,68.094],[251.228,67.502],[253.791,66.376],[256.447,64.713]],[[256.447,64.713],[259.099,63.05],[260.428,61.007],[260.428,58.584]],[[260.428,58.584],[260.428,57.513],[260.033,56.513],[259.249,55.578]],[[259.249,55.578],[258.464,54.647],[257.527,54.181],[256.432,54.181]],[[256.432,54.181],[254.051,54.208],[251.248,56.855],[248.023,62.119]],[[248.023,62.119],[247.146,63.555],[246.441,64.855],[245.828,66.089]],[[245.828,66.089],[245.19,66.731],[244.653,67.348],[243.932,68.013]],[[243.932,68.013],[240.306,71.398],[237.544,73.089],[235.648,73.089]],[[235.648,73.089],[234.23,73.061],[233.117,72.253],[232.313,70.655]],[[232.313,70.655],[231.619,69.344],[231.269,67.89],[231.269,66.297]],[[231.269,66.297],[231.269,65.095],[231.41,64.063],[231.689,63.195]],[[231.689,63.195],[236.022,60.092],[239.298,57.774],[241.523,56.236]],[[241.523,56.236],[241.523,56.236],[241.854,55.986],[241.854,55.986]],[[241.854,55.986],[242.356,55.452],[242.608,54.937],[242.608,54.434]],[[242.608,54.434],[242.608,53.705],[242.049,53.343],[240.941,53.343]],[[240.941,53.343],[240.296,53.343],[239.351,53.566],[238.096,54.013]],[[238.096,54.013],[233.881,55.661],[229.573,59.213],[225.169,64.663]],[[225.169,64.663],[226.925,60.72],[227.857,58.722],[227.972,58.667]],[[227.972,58.667],[231.343,54.901],[235.15,50.128],[239.393,44.355]],[[239.393,44.355],[242.109,40.67],[243.987,36.919],[245.023,33.095]],[[245.023,33.095],[245.142,32.704],[245.202,32.343],[245.202,32.008]],[[245.202,32.008],[245.17,30.055],[244.225,29.079],[242.367,29.079]],[[242.367,29.079],[241.206,29.079],[239.958,29.819],[238.626,31.296]],[[238.626,31.296],[236.785,33.475],[232.916,40.723],[227.021,53.047]],[[227.021,53.047],[226.107,54.961],[225.289,56.693],[224.514,58.341]],[[224.514,58.341],[223.364,59.486],[221.496,61.465],[218.721,64.511]],[[218.721,64.511],[214.272,69.392],[211.016,71.833],[208.953,71.833]],[[208.953,71.833],[208.158,71.833],[207.76,71.313],[207.76,70.278]],[[207.76,70.278],[207.76,68.68],[208.701,65.174],[210.592,59.763]],[[210.592,59.763],[211.212,58.166],[211.526,57.308],[211.526,57.197]],[[211.526,57.197],[211.526,56.217],[210.731,55.726],[209.138,55.726]],[[209.138,55.726],[208.953,55.726],[208.772,55.754],[208.597,55.809]],[[208.597,55.809],[208.709,55.391],[208.764,55.07],[208.764,54.847]],[[208.764,54.847],[208.764,52.978],[207.691,52.044],[205.543,52.044]],[[205.543,52.044],[202.335,52.044],[198.989,54.453],[195.503,59.271]],[[195.503,59.271],[194.865,60.149],[194.157,61.3],[193.414,62.576]],[[193.414,62.576],[193.233,62.782],[193.048,63.064],[192.868,63.256]],[[192.868,63.256],[191.333,64.901],[189.368,66.7],[186.97,68.653]],[[186.97,68.653],[183.874,71.219],[181.754,72.501],[180.611,72.501]],[[180.611,72.501],[179.886,72.501],[179.523,71.901],[179.523,70.702]],[[179.523,70.702],[179.523,68.834],[180.527,65.362],[182.535,60.285]],[[182.535,60.285],[183.372,58.138],[183.791,56.868],[183.791,56.478]],[[183.791,56.478],[183.791,55.224],[183.08,54.595],[181.657,54.595]],[[181.657,54.595],[181.379,54.595],[181.155,54.624],[180.988,54.679]],[[180.988,54.679],[180.402,54.846],[177.819,57.245],[173.242,61.875]],[[173.242,61.875],[169.884,65.25],[167.887,67.258],[167.245,67.899]],[[167.245,67.899],[167.412,67.147],[167.733,66.059],[168.206,64.636]],[[168.206,64.636],[169.576,60.396],[170.263,58.109],[170.263,57.775]],[[170.263,57.775],[170.263,57.218],[169.869,56.722],[169.089,56.29]],[[169.089,56.29],[168.303,55.857],[167.635,55.642],[167.073,55.642]],[[167.073,55.642],[166.631,55.642],[164.068,58.068],[159.389,62.922]],[[159.389,62.922],[155.77,66.575],[153.846,68.542],[153.623,68.82]],[[153.623,68.82],[153.623,68.82],[153.999,68.235],[153.999,68.235]],[[153.999,68.235],[155.003,66.31],[156.045,64.372],[157.123,62.42]],[[157.123,62.42],[158.667,59.547],[159.441,57.859],[159.441,57.358]],[[159.441,57.358],[159.413,55.991],[158.724,55.307],[157.37,55.307]],[[157.37,55.307],[156.293,55.307],[155.617,56.047],[155.341,57.525]],[[155.341,57.525],[155.286,57.692],[155.058,58.208],[154.668,59.072]],[[154.668,59.072],[154.222,60.01],[153.814,60.868],[153.41,61.718]],[[153.41,61.718],[147.667,69.046],[143.45,72.752],[140.793,72.752]],[[140.793,72.752],[139.643,72.725],[139.067,71.898],[139.067,70.27]],[[139.067,70.27],[139.067,68.478],[139.827,65.874],[141.346,62.454]],[[141.346,62.454],[142.866,59.037],[143.626,57.135],[143.626,56.747]],[[143.626,56.747],[143.626,55.314],[142.709,54.596],[140.876,54.596]],[[140.876,54.596],[138.254,54.596],[134.168,57.989],[128.618,64.77]],[[128.618,64.77],[128.618,64.77],[129.12,63.78],[129.12,63.78]],[[129.12,63.78],[130.04,61.792],[130.667,60.482],[131.003,59.851]],[[131.003,59.851],[134.322,56.093],[137.808,51.599],[141.465,46.366]],[[141.465,46.366],[146.446,39.296],[148.939,34.509],[148.939,32.007]],[[148.939,32.007],[148.939,30.111],[148.116,29.162],[146.471,29.162]],[[146.471,29.162],[144.732,29.162],[142.374,31.525],[139.404,36.246]],[[139.404,36.246],[138.484,37.72],[136.709,40.932],[134.091,45.878]],[[134.091,45.878],[132.637,48.605],[130.371,53.199],[127.314,59.614]],[[127.314,59.614],[124.219,62.794],[120.994,65.52],[117.612,67.675]],[[117.612,67.675],[112.982,70.613],[108.754,72.085],[104.933,72.085]],[[104.933,72.085],[104.427,72.112],[104.176,71.806],[104.176,71.165]],[[104.176,71.165],[104.176,69.157],[105.406,66.298],[107.871,62.589]],[[107.871,62.589],[111.201,57.68],[113.637,55.227],[115.178,55.227]],[[115.178,55.227],[115.346,55.227],[115.428,55.366],[115.428,55.645]],[[115.428,55.645],[115.428,56.342],[115.086,57.52],[114.4,59.18]],[[114.4,59.18],[113.713,60.839],[113.372,61.837],[113.372,62.171]],[[113.372,62.171],[113.344,62.896],[113.7,63.259],[114.443,63.259]],[[114.443,63.259],[115.161,63.287],[115.792,62.956],[116.343,62.261]],[[116.343,62.261],[116.782,61.735],[117.312,60.456],[117.933,58.42]],[[117.933,58.42],[118.549,56.383],[118.86,54.993],[118.86,54.247]],[[118.86,54.247],[118.86,53.385],[118.525,52.723],[117.86,52.253]],[[117.86,52.253],[117.194,51.782],[116.49,51.545],[115.757,51.545]],[[115.757,51.545],[114.976,51.545],[114.185,51.768],[113.38,52.211]],[[113.38,52.211],[111.267,53.575],[108.743,56.112],[105.812,59.835]],[[105.812,59.835],[104.818,61.097],[104.017,62.244],[103.301,63.338]],[[103.301,63.338],[102.098,64.639],[101.01,66.009],[99.703,67.244]],[[99.703,67.244],[96.05,70.75],[93.274,72.504],[91.378,72.504]],[[91.378,72.504],[90.566,72.504],[90.162,71.988],[90.162,70.949]],[[90.162,70.949],[90.19,68.966],[90.89,66.222],[92.26,62.725]],[[92.26,62.725],[93.464,59.731],[94.753,57.116],[96.123,54.878]],[[96.123,54.878],[98.581,50.942],[100.522,47.442],[101.945,44.378]],[[101.945,44.378],[105.592,43.514],[108.311,42.872],[110.11,42.446]],[[110.11,42.446],[111.905,42.021],[113.673,41.602],[115.416,41.192]],[[115.416,41.192],[117.483,40.731],[119.23,40.501],[120.656,40.501]],[[120.656,40.501],[122.079,40.501],[122.793,40.014],[122.793,39.03]],[[122.793,39.03],[122.793,38.173],[122.277,37.74],[121.246,37.74]],[[121.246,37.74],[119.52,37.74],[117.456,38.029],[115.061,38.612]],[[115.061,38.612],[109.926,39.686],[106.074,40.536],[103.508,41.171]],[[103.508,41.171],[104.763,38.159],[105.39,36.221],[105.39,35.356]],[[105.39,35.356],[105.39,33.905],[104.763,33.181],[103.508,33.181]],[[103.508,33.181],[102.755,33.181],[102.183,33.585],[101.793,34.394]],[[101.793,34.394],[101.793,34.394],[97.847,42.175],[97.847,42.175]],[[97.847,42.175],[94.967,42.65],[92.133,42.886],[89.336,42.886]],[[89.336,42.886],[88.695,42.886],[87.751,42.817],[86.509,42.677]],[[86.509,42.677],[85.265,42.538],[84.323,42.468],[83.681,42.468]],[[83.681,42.468],[82.758,42.441],[82.297,42.802],[82.297,43.556]],[[82.297,43.556],[82.297,45.341],[84.079,46.234],[87.642,46.234]],[[87.642,46.234],[90.26,46.205],[93.115,45.969],[96.208,45.523]],[[96.208,45.523],[92.923,52.125],[90.961,56.225],[90.323,57.818]],[[90.323,57.818],[90.173,58.16],[90.071,58.466],[89.932,58.802]],[[89.932,58.802],[88.746,60.011],[87.004,61.877],[84.598,64.515]],[[84.598,64.515],[80.15,69.396],[76.894,71.837],[74.83,71.837]],[[74.83,71.837],[74.035,71.837],[73.638,71.317],[73.638,70.282]],[[73.638,70.282],[73.638,68.684],[74.579,65.178],[76.469,59.767]],[[76.469,59.767],[77.09,58.17],[77.403,57.312],[77.403,57.201]],[[77.403,57.201],[77.403,56.221],[76.608,55.73],[75.015,55.73]],[[75.015,55.73],[74.83,55.73],[74.649,55.758],[74.475,55.813]],[[74.475,55.813],[74.586,55.395],[74.642,55.074],[74.642,54.851]],[[74.642,54.851],[74.642,52.982],[73.568,52.048],[71.42,52.048]],[[71.42,52.048],[68.213,52.048],[64.867,54.457],[61.38,59.275]],[[61.38,59.275],[60.742,60.153],[60.034,61.304],[59.291,62.58]],[[59.291,62.58],[59.111,62.786],[58.926,63.068],[58.745,63.26]],[[58.745,63.26],[57.21,64.905],[55.245,66.704],[52.846,68.657]],[[52.846,68.657],[49.75,71.223],[47.631,72.505],[46.487,72.505]],[[46.487,72.505],[45.762,72.505],[45.399,71.905],[45.399,70.706]],[[45.399,70.706],[45.399,68.838],[46.403,65.366],[48.411,60.289]],[[48.411,60.289],[49.248,58.142],[49.666,56.872],[49.666,56.482]],[[49.666,56.482],[49.666,55.228],[48.955,54.599],[47.533,54.599]],[[47.533,54.599],[47.254,54.599],[47.031,54.628],[46.864,54.683]],[[46.864,54.683],[46.278,54.85],[43.695,57.249],[39.117,61.879]],[[39.117,61.879],[35.76,65.254],[33.763,67.262],[33.12,67.903]],[[33.12,67.903],[33.288,67.151],[33.608,66.063],[34.083,64.64]],[[34.083,64.64],[35.453,60.4],[36.14,58.113],[36.14,57.779]],[[36.14,57.779],[36.14,57.222],[35.746,56.726],[34.965,56.294]],[[34.965,56.294],[34.181,55.861],[33.511,55.646],[32.95,55.646]],[[32.95,55.646],[32.507,55.646],[29.945,58.072],[25.266,62.926]],[[25.266,62.926],[21.648,66.579],[19.724,68.546],[19.5,68.824]],[[19.5,68.824],[19.5,68.824],[19.877,68.239],[19.877,68.239]],[[19.877,68.239],[20.881,66.314],[21.923,64.376],[23.001,62.424]],[[23.001,62.424],[24.545,59.551],[25.32,57.863],[25.32,57.362]],[[25.32,57.362],[25.291,55.995],[24.601,55.311],[23.248,55.311]],[[23.248,55.311],[22.171,55.311],[21.495,56.051],[21.22,57.529]],[[21.22,57.529],[21.164,57.696],[20.938,58.212],[20.547,59.076]],[[20.547,59.076],[15.948,68.726],[13.648,73.662],[13.648,73.886]],[[13.648,73.886],[13.648,74.36],[14.056,74.737],[14.869,75.015]],[[14.869,75.015],[15.513,75.294],[16.113,75.405],[16.674,75.35]],[[16.674,75.35],[16.674,75.35],[16.841,75.35],[16.841,75.35]],[[16.841,75.35],[16.956,75.35],[17.067,75.35],[17.18,75.35]],[[17.18,75.35],[17.43,75.294],[18.901,73.872],[21.593,71.083]],[[21.593,71.083],[26.767,65.756],[30.037,62.437],[31.4,61.127]],[[31.4,61.127],[31.4,61.127],[29.933,65.686],[29.933,65.686]],[[29.933,65.686],[28.729,69.395],[28.13,71.39],[28.13,71.668]],[[28.13,71.668],[28.13,72.7],[28.901,73.215],[30.439,73.215]],[[30.439,73.215],[30.857,73.215],[31.205,73.16],[31.484,73.048]],[[31.484,73.048],[35.957,68.976],[40.137,64.974],[44.021,61.042]],[[44.021,61.042],[42.654,64.751],[41.97,67.861],[41.97,70.371]],[[41.97,70.371],[41.97,74.025],[43.142,75.851],[45.484,75.851]],[[45.484,75.851],[47.632,75.851],[50.826,74.025],[55.065,70.371]],[[55.065,70.371],[55.413,70.072],[55.633,69.82],[55.961,69.527]],[[55.961,69.527],[55.706,70.322],[55.483,71.079],[55.483,71.584]],[[55.483,71.584],[55.483,72.184],[55.79,72.908],[56.403,73.752]],[[56.403,73.752],[57.017,74.6],[57.7,75.022],[58.453,75.022]],[[58.453,75.022],[60.572,75.022],[64.659,71.954],[70.71,65.821]],[[70.71,65.821],[70.376,67.196],[70.208,68.457],[70.208,69.608]],[[70.208,69.608],[70.208,73.435],[71.589,75.349],[74.35,75.349]],[[74.35,75.349],[77.965,75.349],[82.431,71.947],[87.667,65.444]],[[87.667,65.444],[87.171,67.443],[86.9,69.261],[86.9,70.865]],[[86.9,70.865],[86.9,74.025],[88.253,75.599],[90.962,75.599]],[[90.962,75.599],[93.622,75.599],[96.795,73.86],[100.448,70.506]],[[100.448,70.506],[100.445,70.597],[100.413,70.695],[100.413,70.789]],[[100.413,70.789],[100.413,73.885],[102.184,75.433],[105.733,75.433]],[[105.733,75.433],[109.303,75.433],[113.946,73.494],[119.664,69.617]],[[119.664,69.617],[121.456,68.384],[122.958,67.191],[124.333,66.016]],[[124.333,66.016],[122.422,70.221],[121.417,72.742],[121.417,73.39]],[[121.417,73.39],[121.417,74.809],[122.07,75.516],[123.384,75.516]],[[123.384,75.516],[123.718,75.516],[124.022,75.485],[124.304,75.426]],[[124.304,75.426],[124.943,75.304],[125.696,74.506],[126.564,73.028]],[[126.564,73.028],[127.149,72.007],[127.717,71.012],[128.279,70.044]],[[128.279,70.044],[131.065,65.738],[134.774,61.803],[139.407,58.24]],[[139.407,58.24],[137.257,62.981],[136.155,66.485],[136.099,68.744]],[[136.099,68.744],[136.099,68.883],[136.099,69.019],[136.099,69.159]],[[136.099,69.159],[136.099,73.398],[137.692,75.517],[140.879,75.517]],[[140.879,75.517],[143.067,75.517],[145.979,73.6],[149.59,69.81]],[[149.59,69.81],[148.384,72.401],[147.771,73.771],[147.771,73.886]],[[147.771,73.886],[147.771,74.36],[148.179,74.737],[148.991,75.015]],[[148.991,75.015],[149.636,75.294],[150.236,75.405],[150.797,75.35]],[[150.797,75.35],[150.797,75.35],[150.965,75.35],[150.965,75.35]],[[150.965,75.35],[151.079,75.35],[151.191,75.35],[151.302,75.35]],[[151.302,75.35],[151.553,75.294],[153.025,73.872],[155.716,71.083]],[[155.716,71.083],[160.89,65.756],[164.159,62.437],[165.522,61.127]],[[165.522,61.127],[165.522,61.127],[164.054,65.686],[164.054,65.686]],[[164.054,65.686],[162.852,69.395],[162.252,71.39],[162.252,71.668]],[[162.252,71.668],[162.252,72.7],[163.023,73.215],[164.559,73.215]],[[164.559,73.215],[164.978,73.215],[165.326,73.16],[165.605,73.048]],[[165.605,73.048],[170.077,68.976],[174.258,64.974],[178.141,61.042]],[[178.141,61.042],[176.775,64.751],[176.092,67.861],[176.092,70.371]],[[176.092,70.371],[176.092,74.025],[177.262,75.851],[179.606,75.851]],[[179.606,75.851],[181.753,75.851],[184.947,74.025],[189.187,70.371]],[[189.187,70.371],[189.535,70.072],[189.755,69.82],[190.083,69.527]],[[190.083,69.527],[189.828,70.322],[189.605,71.079],[189.605,71.584]],[[189.605,71.584],[189.605,72.184],[189.912,72.908],[190.525,73.752]],[[190.525,73.752],[191.138,74.6],[191.822,75.022],[192.575,75.022]],[[192.575,75.022],[194.695,75.022],[198.781,71.954],[204.832,65.821]],[[204.832,65.821],[204.498,67.196],[204.33,68.457],[204.33,69.608]],[[204.33,69.608],[204.33,73.435],[205.71,75.349],[208.471,75.349]],[[208.471,75.349],[211.825,75.349],[215.918,72.375],[220.67,66.784]],[[220.67,66.784],[219.024,70.563],[218.178,72.86],[218.178,73.581]],[[218.178,73.581],[218.178,74.76],[218.694,75.349],[219.725,75.349]],[[219.725,75.349],[220.059,75.349],[220.394,75.321],[220.729,75.266]],[[220.729,75.266],[221.37,75.074],[222.291,74.167],[223.491,72.547]],[[223.491,72.547],[226.056,68.747],[227.659,66.523],[228.302,65.881]],[[228.302,65.881],[228.302,68.384],[228.793,70.539],[229.773,72.347]],[[229.773,72.347],[231.013,74.795],[232.847,76.018],[235.274,76.018]],[[235.274,76.018],[237.693,76.018],[240.548,74.544],[243.791,71.765]],[[243.791,71.765],[243.715,72.232],[243.614,72.717],[243.614,73.125]],[[243.614,73.125],[243.614,74.191],[244.059,75.07],[244.952,75.768]],[[244.952,75.768],[245.845,76.46600000000001],[246.807,76.813],[247.839,76.813]],[[247.839,76.813],[251.214,76.813],[255.44,74.98],[260.516,71.312]],[[260.516,71.312],[265.118,67.979],[268.506,64.675],[270.681,61.397]],[[270.681,61.397],[270.779,61.247],[270.758,61.104],[270.834,60.955]],[[270.834,60.955],[271.354,60.868],[272.229,60.676],[273.776,60.288]],[[273.776,60.288],[273.776,60.288],[276.245,59.577],[276.245,59.577]],[[276.245,59.577],[272.201,66.013],[270.179,70.284],[270.179,72.382]],[[270.179,72.382],[270.179,74.415],[271.545,75.433],[274.279,75.433]],[[274.279,75.433],[275.98,75.433],[277.863,74.973],[279.927,74.052]],[[279.927,74.052],[281.739,73.271],[284.165,71.277],[287.206,68.07]],[[287.206,68.07],[290.022,65.113],[292.002,62.632],[293.146,60.624]],[[293.146,60.624],[293.313,60.261],[293.396,59.941],[293.396,59.662]],[[293.396,59.662],[293.365,59.046],[293.1,58.74],[292.598,58.74]]];

	percent = 0
	total = 0
	forwards = []
	for p in points
		b = bezier p
		total += b.length
		forwards.push b
	for forward, i in forwards
		forward.i = i
		forward.percent = forward.length/total
		percent += forward.percent
		forward.position = percent
		if i isnt 0 then forward.prior = forwards[i - 1].position else forward.prior = 0

	percent = 0
	backwards = []
	for p in _.clone(points).reverse()
		backwards.push bezier _.clone(p).reverse()
	for backward, i in backwards
		backward.i = i
		backward.percent = backward.length/total
		percent += backward.percent
		backward.position = percent
		if i isnt 0 then backward.prior = backwards[i - 1].position else backward.prior = 0

	animate = () ->	
		current = 0
		reverse = 0
		start = 'M ' + points[0][0][0] + ', ' + points[0][0][1] + ' '
		front = []
		back = []
		Animate 0, 0.5, 100000, 'linear', (a) ->
			nextCurrent = _.find forwards, (f) -> return f.position > a
			nextReverse = _.find backwards, (f) -> return f.position > a
			if nextCurrent.i > current
				end = current + nextCurrent.i - current - 1
				for i in [current..end]
					f = forwards[i]
					front[i] = 'C ' + [f.cp0[0], f.cp0[1], f.cp1[0], f.cp1[1], f.x(1), f.y(1)].join(' ')
			if nextReverse.i > reverse
				end = reverse + nextReverse.i - reverse - 1
				for i in [reverse..end]
					b = backwards[i]
					back[i] = 'C ' + [b.cp1[0], b.cp1[1], b.cp0[0], b.cp0[1], b.start[0], b.start[1]].join(' ')
			current = nextCurrent.i
			reverse = nextReverse.i
			fpercent = (a - nextCurrent.prior)/nextCurrent.percent
			rpercent = (a - nextReverse.prior)/nextReverse.percent
			f = forwards[current]
			if f?
				x = f.x(fpercent)
				y = f.y(fpercent)
				front[current] = 'C ' + [f.cp0x(fpercent), f.cp0y(fpercent), f.cp1x(fpercent), f.cp1y(fpercent), x, y].join(' ')
			b = backwards[reverse]
			if b?
				x = b.x(rpercent)
				y = b.y(rpercent)
				back[reverse] = 'C ' + [b.cp1x(rpercent), b.cp1y(rpercent), b.cp0x(rpercent), b.cp0y(rpercent), b.start[0], b.start[1]].join(' ')
				start = ['M', x, y].join(' ')
			path.setAttribute('d', start + _.clone(back).reverse().join(' ') + ' ' + front.join(' '))	
		, animate


	animate()












# animate = () ->	
# 	current = 0
# 	start = 'M ' + points[0][0][0] + ', ' + points[0][0][1] + ' '
# 	front = []
# 	back = []
# 	Animate 0, forwards.length/2, 10000, 'linear', (a) ->
# 		if Math.floor(a) > current
# 			end = current + Math.floor(a) - current - 1
# 			for i in [current..end]
# 				f = forwards[i]
# 				front[i] = 'C ' + [f.cp0[0], f.cp0[1], f.cp1[0], f.cp1[1], f.x(1), f.y(1)].join(' ')
# 				b = backwards[i]
# 				back[current] = 'C ' + [b.cp1[0], b.cp1[1], b.cp0[0], b.cp0[1], b.start[0], b.start[1]].join(' ')
# 		current = Math.floor(a)
# 		percent = a % 1
# 		f = forwards[current]
# 		if f?
# 			x = f.x(percent)
# 			y = f.y(percent)
# 			front[current] = 'C ' + [f.cp0x(percent), f.cp0y(percent), f.cp1x(percent), f.cp1y(percent), x, y].join(' ')
# 		b = backwards[current]
# 		if b?
# 			x = b.x(percent)
# 			y = b.y(percent)
# 			back[current] = 'C ' + [b.cp1x(percent), b.cp1y(percent), b.cp0x(percent), b.cp0y(percent), b.start[0], b.start[1]].join(' ')
# 			start = ['M', x, y].join(' ')
# 		path.setAttribute('d', start + _.clone(back).reverse().join(' ') + ' ' + front.join(' '))	
# 	, animate




				