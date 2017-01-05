/*-----------------------------------
::  NAMESPACE
-------------------------------------*/
Tmobile = {};

var namespace = namespace || 'Tmobile';

(function ($, A) {
    A = A || {}
    A.Models = A.Models || {};
    A.Views = A.Views || {};
    A.Controls = A.Controls || {};
    A.Controls.Animators = [];

    A.Models.Gallery = Backbone.Model.extend({

        defaults: {
            current: -1,
            length: undefined,
            loop: false,
            reverse: false,
            framerate: 1000 / 60,
            trackFirst: true,
            trackLast: true,
            trackPercent: true,
            isFirst: undefined,
            isLast: undefined
        },

        initialize: function () {
            this.on('track', this.testFirstAndLast);
            if (this.get('trackFirst')) this.on('change:isFirst', this.testBegin);
            if (this.get('trackLast')) this.on('change:isLast', this.testComplete);
            if (this.get('trackPercent')) this.on('track', this.trackPercent);
        },

        /*--------------------------
        ::  STATE TESTS
        ---------------------------*/
        testInitialized: function _ths0() {
            if (!_ths0.initialized && _.isUndefined(this.get('current'))) {
                this.set({ current: 0 });
                _ths0.initialized = true;
            }
        },

        testFirstAndLast: function () {
            var total = this.get('length') - 1;
            if (this.get('current') <= 0) this.set({ isFirst: true }); else this.set({ isFirst: false });
            if (this.get('current') >= total) this.set({ isLast: true }); else this.set({ isLast: false });
        },

        testBegin: function () {
            if (this.get('isFirst')) this.trigger('begin');
        },

        testComplete: function () {
            if (this.get('isLast')) {
                this.trigger('complete');
                if (!this.get('loop')) this.pause();
            }
        },

        trackPercent: function () {
            var total = this.get('length') - 1;
            if (this.get('current') !== 0) {
                this.set({ percent: this.get('current') / total });
            } else {
                switch (total) {
                    case 0: this.set({ percent: 1 }); break;
                    default: this.set({ percent: 0 });
                }
            }
        },

        isUnique: function _ths(key) {
            _ths[key + 'first'] = (!_.isUndefined(_ths[key + 'first'])) ? _ths[key + 'first'] : true;
            _ths[key] = _ths[key] || new Date();
            if (_ths[key + 'first']) { _ths[key + 'first'] = false; return true; }
            _ths.duration = _ths.duration || parseInt(this.get('framerate'));
            if (parseInt(new Date() - _ths[key]) > _ths.duration) { _ths[key] = new Date(); return true; }
            else { return false; }
        },

        /*--------------------------
        ::  FUNCTIONALITY
        ---------------------------*/
        seek: function _ths(current, options) {
            options = options || {};
            if (!_ths.initialized) { this.testInitialized(); _ths.initialized = true; }
            var total = this.get('length') - 1;
            if (current === 0 || current === total) this.set({ current: current }, options);
            else if (current <= 0 && !this.get('loop')) this.set({ current: 0 }, options);
            else if (current >= total && !this.get('loop')) this.set({ current: total }, options);
            else if (current <= 0 && this.get('loop')) this.seek(total + current + 1, options);
            else if (current >= total && this.get('loop')) this.seek(current - 1 - total, options);
            else this.set({ current: current }, (this.isUnique('seek')) ? options : { silent: true });
            this.trigger('track');
            return this;
        },

        previous: function _ths() {
            if (!_ths.initialized) { this.testInitialized(); _ths.initialized = true; }
            this.seek(this.get('current') - 1);
            return this;
        },

        next: function _ths() {
            if (!_ths.initialized) { this.testInitialized(); _ths.initialized = true; }
            this.seek(this.get('current') + 1);
            return this;
        },

        play: function () {
            var self = this;
            if (this.get('isPlaying')) return;
            this.set({ isPlaying: true });
            self.next();
            this.interval = setInterval(function () {
                if (self.get('reverse')) self.previous(); else self.next();
            }, this.get('framerate'));
            return this;
        },

        pause: function () {
            if (!this.get('isPlaying')) return;
            this.set({ isPlaying: false });
            clearInterval(this.interval);
            return this;
        },

        reverse: function () {
            if (this.get('reverse')) this.set({ reverse: false }); else this.set({ reverse: true });
        },

        /*--------------------------
        ::  ANIMATION UTILITIES
        ---------------------------*/
        animate: function (start, end, easing, duration) {
            this.clear();
            this.i = this.i + 1 || 0;
            this.stepAnimate(start, end, this.i, easing, duration);
        },

        stepAnimate: function (start, end, i, easing, duration) {
            var self = this;
            this.attributes['animation' + i] = true;
            this.on('clear' + i, function () { delete self.attributes['animation' + i]; self.off('clear' + i); });
            $({ delta: start }).animate({ delta: end }, {
                step: function (now, fx) { if (self.attributes['animation' + i]) { self.seek(now); } },
                easing: easing || 'swing',
                duration: duration || 800,
                complete: function () { self.trigger('clear' + i); }
            });
        },

        clear: function () {
            this.trigger('clear' + this.i);
            return this;
        },

        /*--------------------------
        ::  FLICK UTILITIES
        ---------------------------*/
        flick: function (start, velocity, width, breakpoints) {
            var self = this;
            if (Math.abs(velocity) < 0.1) velocity = 0;
            $.easing.flick = function (x, t, b, c, d) { return -c * (t /= d) * (t - 2) + b; };
            var end = start + (velocity * 40);
            var count;
            if (velocity > 0) {
                var breakpoints = this.get(breakpoints).forward;
                end = _.find(breakpoints, function (value, i) { count = i; return value >= end; });
                end = end || _.max(breakpoints, function (value, i) { count = i; return value; });
            } else {
                var breakpoints = this.get(breakpoints).reverse;
                end = _.find(breakpoints, function (value, i) { count = breakpoints.length - i - 1; return value <= end; });
                end = end || _.min(breakpoints, function (value, i) { count = breakpoints.length - i - 1; return value; });
            }
            var duration = Math.abs((start - end) / velocity) * 2;
            this.animate(this.get('current'), count, 'flick', 600);
        }

    });

    /*-----------------------------------
    :: CORE ANIMATOR VIEW
    -------------------------------------*/
    A.Controls.Animator = Backbone.View.extend({

        initialize: function () {
            var self = this;
            this.model = new A.Models.Gallery(this.options);
            // A.Views.Gallery.prototype.initialize.call(this);
            this.model.set({
                height: (this.model.get('height')) ? parseInt(this.model.get('height').toString().replace(/[^0-9]+/g, '')) : this.$el.height(),
                width: (this.model.get('width')) ? parseInt(this.model.get('width').toString().replace(/[^0-9]+/g, '')) : this.$el.width()
            });
            if (window.devicePixelRatio == 2 && this.model.has('retinaSprite')) this.model.set({ sprite: this.model.get('retinaSprite') });
            var animate = (this.hasCanvas()) ? 'animateCanvas' : 'animateBackground';
            this.model.on('change:current', this[animate], this);
            this.render();
        },

        hasCanvas: function() {
        	return true;
        },

        /*--------------------------
        ::  CORE METHODS
        ---------------------------*/
        show: function () {
            var self = this;
            var animate = (this.browserHas('transition') !== false) ? 'css' : 'animate';
            setTimeout(function () { self.$el.find('.spinner-images')[animate]({ opacity: 1 }, 'slow'); self.$el.find('.spinner-indicator')[animate]({ opacity: 0.5 }, 'slow'); }, 800);
        },

        image: function () {
            var total = this.model.get('length') - 1;
            var percent = this.model.get('current') / total;
            return (percent < 1) ? Math.floor(percent * this.model.get('sprite').length) : (this.model.get('sprite').length - 1);
        },

        left: function (i) {
            this.total = this.total || this.model.get('length') - 1;
            this.center = this.center || parseInt(this.total / 2);
            this.width = this.width || this.model.get('width');
            return ((-this.model.get('current') * this.width) + ((this.total + 1) / this.model.get('sprite').length * i * this.width));
        },

        animateBackground: function () {
            var i = this.image();
            this.$el.find('.spinner-image-sprite').css('background', 'url("' + this.model.get('sprite')[i] + '") no-repeat ' + this.left(i) + 'px 0');
        },

        animateCanvas: function () {
            var i = this.image();
            this.width = this.width || this.model.get('width');
            this.height = this.height || this.model.get('height');
            this.context.clearRect (0, 0, this.width, this.height);
            this.context.drawImage(this.images[i], 0, 0);
        },

        /*--------------------------
        ::  RENDER
        ---------------------------*/
        template: _.template('' +
                '<div class="spinner-images"></div>' +
                '<div class="spinner-overlay"></div>' +
                '<div class="spinner-reflection"></div>' +
            ''),

        itemCanvasTemplate: _.template('<canvas class="spinner-image spinner-image-0" width="<%= width %>" height="<%= height %>"></canvas>'),

        itemBackgroundTemplate: _.template('<img class="spinner-image spinner-image-<%= i %>" src="<%= url %>" />'),

        renderCanvas: function () {
            var self = this;
            this.$el.find('.spinner-images').prepend(self.itemCanvasTemplate(this.model.attributes));
            var canvas = self.$el.find('.spinner-image-0')[0];
            this.context = canvas.getContext('2d');
            _.each(this.model.get('sprite'), function (url, i) {
                self.images = self.images || [];
                self.images.push(new Image());
                self.images[i].onload = function () { /*self.downloaded.next();*/ };
                self.images[i].src = url;
            });
        },

        renderBackground: function () {
            var self = this;
            _.each(this.model.get('sprite'), function (url, i) {
                self.$el.find('.spinner-images').addClass('spinner-image-sequence').prepend(self.itemBackgroundTemplate({ url: url, i: i }));
                self.$el.find('.spinner-image-' + i).load(function () {
                    //self.downloaded.next();
                });
            });
            self.$el.find('.spinner-images').append('<div class="spinner-image-sprite spinner-image active"></div>');
        },

        render: function () {
            var self = this;
            this.$el.prepend(this.template());
            if (this.hasCanvas()) this.renderCanvas();
            else this.renderBackground();
        }

    });

    $.easing.easeInOut = function(x, t, b, c, d) { if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b; return c/2*((t-=2)*t*t*t*t + 2) + b; };

})(window['$'] || jQuery, window[namespace]);