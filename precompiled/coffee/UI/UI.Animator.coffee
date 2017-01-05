#-----------------------------------
#
#	UI > Animator
#
#------------------------------------
if !Date.now?
	Date.now = () ->
    	return new Date().getTime()

define 'UI.Animator', ->

	animate = (start, end, duration, easing, callback, complete) ->

		duration ?= 0

		easingFunc = animate.easing[easing] or animate.easing.swing;

		startValue = start
		difference = end - start
		current = start
		startTime = Date.now()
		pauseStart = startTime
		paused = true
		animationRequestId = undefined
		lastTime = Date.now()

		pause = ->
			if paused then return
			paused = true
			cancelAnimationFrame(animationRequestId)	
			pauseStart = Date.now()

		stop = ->
			pause()

		resume = ->
			if !paused then return
			paused = false
			startTime += Date.now() - pauseStart
			animationRequestId = requestAnimationFrame(step)

		overclocked = ->
			# return 1000/(Date.now() - lastTime) > 60
			return false 

		step = ->
			currentTime = Date.now() - startTime
			x = 1 - ((duration - currentTime)/duration)
			if currentTime < duration && !paused
				if !overclocked()
					current = easingFunc(x, currentTime, start, difference, duration)
					callback && callback(current)
					lastTime = Date.now()
				animationRequestId = requestAnimationFrame(step)
			else
				current = easingFunc(x, duration, start, difference, duration)
				callback && callback(end)
				complete && complete()

		resume()

		return {
			resume: resume,
			pause: pause,
			stop: stop
		}
	
	#	x: percent complete, t: current time, b: begInnIng value, c: change In value, d: duration

	animate.easing = {
		
		linear: (x, t, b, c, d) ->
			return b + (x*c)
		
		swing: (x, t, b, c, d) ->
			return b + ((0.5 - Math.cos(x * Math.PI ) / 2) * c)

		easeInQuad: (x, t, b, c, d) ->
			return c*(t/=d)*t + b
		
		easeOutQuad: (x, t, b, c, d) ->
			return -c *(t/=d)*(t-2) + b
		
		easeInOutQuad: (x, t, b, c, d) ->
			if ((t/=d/2) < 1) then return c/2*t*t + b
			return -c/2 * ((--t)*(t-2) - 1) + b
		
		easeInCubic: (x, t, b, c, d) ->
			return c*(t/=d)*t*t + b
		
		easeOutCubic: (x, t, b, c, d) ->
			return c*((t=t/d-1)*t*t + 1) + b
		
		easeInOutCubic: (x, t, b, c, d) ->
			if ((t/=d/2) < 1) then return c/2*t*t*t + b
			return c/2*((t-=2)*t*t + 2) + b
		
		easeInQuart: (x, t, b, c, d) ->
			return c*(t/=d)*t*t*t + b
		
		easeOutQuart: (x, t, b, c, d) ->
			return -c * ((t=t/d-1)*t*t*t - 1) + b
		
		easeInOutQuart: (x, t, b, c, d) ->
			if ((t/=d/2) < 1) then return c/2*t*t*t*t + b
			return -c/2 * ((t-=2)*t*t*t - 2) + b
		
		easeInQuint: (x, t, b, c, d) ->
			return c*(t/=d)*t*t*t*t + b
		
		easeOutQuint: (x, t, b, c, d) ->
			return c*((t=t/d-1)*t*t*t*t + 1) + b
		
		easeInOutQuint: (x, t, b, c, d) ->
			if ((t/=d/2) < 1) then return c/2*t*t*t*t*t + b
			return c/2*((t-=2)*t*t*t*t + 2) + b
		
		easeInSine: (x, t, b, c, d) ->
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b
		
		easeOutSine: (x, t, b, c, d) ->
			return c * Math.sin(t/d * (Math.PI/2)) + b
		
		easeInOutSine: (x, t, b, c, d) ->
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b
		
		easeInExpo: (x, t, b, c, d) ->
			return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b
		
		easeOutExpo: (x, t, b, c, d) ->
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b
		
		easeInOutExpo: (x, t, b, c, d) ->
			if (t==0) then return b;
			if (t==d) then return b+c;
			if ((t/=d/2) < 1) then return c/2 * Math.pow(2, 10 * (t - 1)) + b
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b
		
		easeInCirc: (x, t, b, c, d) ->
			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b
		
		easeOutCirc: (x, t, b, c, d) ->
			return c * Math.sqrt(1 - (t=t/d-1)*t) + b
		
		easeInOutCirc: (x, t, b, c, d) ->
			if ((t/=d/2) < 1) then return -c/2 * (Math.sqrt(1 - t*t) - 1) + b
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b
		
		easeInElastic: (x, t, b, c, d) ->
			s = 1.70158
			p = 0
			a = c
			if (t==0) then return b 
			if ((t/=d)==1) then return b+c
			if (!p) then p = d * .3
			if (a < Math.abs(c)) 
				a=c 
				s=p/4
			else  
				s = p/(2*Math.PI) * Math.asin (c/a)
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b
		
		easeOutElastic: (x, t, b, c, d) ->
			s=1.70158 
			p=0
			a=c;
			if (t==0) then return b
			if ((t/=d)==1) then return b+c 
			if (!p) then p=d*.3
			if (a < Math.abs(c)) 
				a=c 
				s=p/4
			else 
				s = p/(2*Math.PI) * Math.asin (c/a)
			return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b
		
		easeInOutElastic: (x, t, b, c, d) ->
			s = 1.70158
			p=0
			a=c;
			if (t==0) then return b
			if ((t/=d/2)==2) then return b+c
			if (!p) then p=d*(.3*1.5)
			if (a < Math.abs(c)) 
				a=c
				s=p/4
			else 
				s = p/(2*Math.PI) * Math.asin (c/a)
			if (t < 1) then return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b
		
		easeInBack: (x, t, b, c, d, s) ->
			s ?= 1.70158
			return c*(t/=d)*t*((s+1)*t - s) + b
		
		easeOutBack: (x, t, b, c, d, s) ->
			s ?= 1.70158
			return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b
		
		easeInOutBack: (x, t, b, c, d, s) ->
			s ?= 1.70158; 
			if ((t/=d/2) < 1) then return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b
			return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b
		
		easeInBounce: (x, t, b, c, d) ->
			return c - animate.easing.easeOutBounce(x, d-t, 0, c, d) + b

		easeOutBounce: (x, t, b, c, d) ->
			if ((t/=d) < (1/2.75))
				return c*(7.5625*t*t) + b
			else if (t < (2/2.75))
				return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b
			else if (t < (2.5/2.75))
				return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b
			else
				return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b

		easeInOutBounce: (x, t, b, c, d) ->
			if (t < d/2) then return animate.easing.easeInBounce(x, t*2, 0, c, d) * .5 + b
			return animate.easing.easeOutBounce(x, t*2-d, 0, c, d) * .5 + c*.5 + b

	}

	return animate