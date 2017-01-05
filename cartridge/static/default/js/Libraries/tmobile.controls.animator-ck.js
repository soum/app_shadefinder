/*-----------------------------------
::  NAMESPACE
-------------------------------------*/Tmobile = {};

var namespace = namespace || "Tmobile";

(function($, A) {
    A = A || {};
    A.Models = A.Models || {};
    A.Views = A.Views || {};
    A.Controls = A.Controls || {};
    A.Controls.Animators = [];
    A.Models.Gallery = Backbone.Model.extend({
        defaults: {
            current: -1,
            length: undefined,
            loop: !1,
            reverse: !1,
            framerate: 1e3 / 60,
            trackFirst: !0,
            trackLast: !0,
            trackPercent: !0,
            isFirst: undefined,
            isLast: undefined
        },
        initialize: function() {
            this.on("track", this.testFirstAndLast);
            this.get("trackFirst") && this.on("change:isFirst", this.testBegin);
            this.get("trackLast") && this.on("change:isLast", this.testComplete);
            this.get("trackPercent") && this.on("track", this.trackPercent);
        },
        testInitialized: function _ths0() {
            if (!_ths0.initialized && _.isUndefined(this.get("current"))) {
                this.set({
                    current: 0
                });
                _ths0.initialized = !0;
            }
        },
        testFirstAndLast: function() {
            var total = this.get("length") - 1;
            this.get("current") <= 0 ? this.set({
                isFirst: !0
            }) : this.set({
                isFirst: !1
            });
            this.get("current") >= total ? this.set({
                isLast: !0
            }) : this.set({
                isLast: !1
            });
        },
        testBegin: function() {
            this.get("isFirst") && this.trigger("begin");
        },
        testComplete: function() {
            if (this.get("isLast")) {
                this.trigger("complete");
                this.get("loop") || this.pause();
            }
        },
        trackPercent: function() {
            var total = this.get("length") - 1;
            if (this.get("current") !== 0) this.set({
                percent: this.get("current") / total
            }); else switch (total) {
              case 0:
                this.set({
                    percent: 1
                });
                break;
              default:
                this.set({
                    percent: 0
                });
            }
        },
        isUnique: function _ths(key) {
            _ths[key + "first"] = _.isUndefined(_ths[key + "first"]) ? !0 : _ths[key + "first"];
            _ths[key] = _ths[key] || new Date;
            if (_ths[key + "first"]) {
                _ths[key + "first"] = !1;
                return !0;
            }
            _ths.duration = _ths.duration || parseInt(this.get("framerate"));
            if (parseInt(new Date - _ths[key]) > _ths.duration) {
                _ths[key] = new Date;
                return !0;
            }
            return !1;
        },
        seek: function _ths(current, options) {
            options = options || {};
            if (!_ths.initialized) {
                this.testInitialized();
                _ths.initialized = !0;
            }
            var total = this.get("length") - 1;
            current === 0 || current === total ? this.set({
                current: current
            }, options) : current <= 0 && !this.get("loop") ? this.set({
                current: 0
            }, options) : current >= total && !this.get("loop") ? this.set({
                current: total
            }, options) : current <= 0 && this.get("loop") ? this.seek(total + current + 1, options) : current >= total && this.get("loop") ? this.seek(current - 1 - total, options) : this.set({
                current: current
            }, this.isUnique("seek") ? options : {
                silent: !0
            });
            this.trigger("track");
            return this;
        },
        previous: function _ths() {
            if (!_ths.initialized) {
                this.testInitialized();
                _ths.initialized = !0;
            }
            this.seek(this.get("current") - 1);
            return this;
        },
        next: function _ths() {
            if (!_ths.initialized) {
                this.testInitialized();
                _ths.initialized = !0;
            }
            this.seek(this.get("current") + 1);
            return this;
        },
        play: function() {
            var self = this;
            if (this.get("isPlaying")) return;
            this.set({
                isPlaying: !0
            });
            self.next();
            this.interval = setInterval(function() {
                self.get("reverse") ? self.previous() : self.next();
            }, this.get("framerate"));
            return this;
        },
        pause: function() {
            if (!this.get("isPlaying")) return;
            this.set({
                isPlaying: !1
            });
            clearInterval(this.interval);
            return this;
        },
        reverse: function() {
            this.get("reverse") ? this.set({
                reverse: !1
            }) : this.set({
                reverse: !0
            });
        },
        animate: function(start, end, easing, duration) {
            this.clear();
            this.i = this.i + 1 || 0;
            this.stepAnimate(start, end, this.i, easing, duration);
        },
        stepAnimate: function(start, end, i, easing, duration) {
            var self = this;
            this.attributes["animation" + i] = !0;
            this.on("clear" + i, function() {
                delete self.attributes["animation" + i];
                self.off("clear" + i);
            });
            $({
                delta: start
            }).animate({
                delta: end
            }, {
                step: function(now, fx) {
                    self.attributes["animation" + i] && self.seek(now);
                },
                easing: easing || "swing",
                duration: duration || 800,
                complete: function() {
                    self.trigger("clear" + i);
                }
            });
        },
        clear: function() {
            this.trigger("clear" + this.i);
            return this;
        },
        flick: function(start, velocity, width, breakpoints) {
            var self = this;
            Math.abs(velocity) < .1 && (velocity = 0);
            $.easing.flick = function(x, t, b, c, d) {
                return -c * (t /= d) * (t - 2) + b;
            };
            var end = start + velocity * 40, count;
            if (velocity > 0) {
                var breakpoints = this.get(breakpoints).forward;
                end = _.find(breakpoints, function(value, i) {
                    count = i;
                    return value >= end;
                });
                end = end || _.max(breakpoints, function(value, i) {
                    count = i;
                    return value;
                });
            } else {
                var breakpoints = this.get(breakpoints).reverse;
                end = _.find(breakpoints, function(value, i) {
                    count = breakpoints.length - i - 1;
                    return value <= end;
                });
                end = end || _.min(breakpoints, function(value, i) {
                    count = breakpoints.length - i - 1;
                    return value;
                });
            }
            var duration = Math.abs((start - end) / velocity) * 2;
            this.animate(this.get("current"), count, "flick", 600);
        }
    });
    A.Controls.Animator = Backbone.View.extend({
        initialize: function() {
            var self = this;
            this.model = new A.Models.Gallery(this.options);
            this.model.set({
                height: this.model.get("height") ? parseInt(this.model.get("height").toString().replace(/[^0-9]+/g, "")) : this.$el.height(),
                width: this.model.get("width") ? parseInt(this.model.get("width").toString().replace(/[^0-9]+/g, "")) : this.$el.width()
            });
            window.devicePixelRatio == 2 && this.model.has("retinaSprite") && this.model.set({
                sprite: this.model.get("retinaSprite")
            });
            var animate = this.hasCanvas() ? "animateCanvas" : "animateBackground";
            this.model.on("change:current", this[animate], this);
            this.render();
        },
        show: function() {
            var self = this, animate = this.browserHas("transition") !== !1 ? "css" : "animate";
            setTimeout(function() {
                self.$el.find(".spinner-images")[animate]({
                    opacity: 1
                }, "slow");
                self.$el.find(".spinner-indicator")[animate]({
                    opacity: .5
                }, "slow");
            }, 800);
        },
        image: function() {
            var total = this.model.get("length") - 1, percent = this.model.get("current") / total;
            return percent < 1 ? Math.floor(percent * this.model.get("sprite").length) : this.model.get("sprite").length - 1;
        },
        left: function(i) {
            this.total = this.total || this.model.get("length") - 1;
            this.center = this.center || parseInt(left.total / 2);
            this.width = this.width || this.model.get("width");
            return -this.model.get("current") * this.width + (this.total + 1) / this.model.get("sprite").length * i * this.width;
        },
        animateBackground: function() {
            var i = this.image();
            this.$el.find(".spinner-image-sprite").css("background", 'url("' + this.model.get("sprite")[i] + '") no-repeat ' + this.left(i) + "px 0");
        },
        animateCanvas: function() {
            var i = this.image();
            this.width = this.width || this.model.get("width");
            this.height = this.height || this.model.get("height");
            this.context.clearRect(0, 0, this.width, this.height);
            this.context.drawImage(this.images[i], this.left(i), 0);
        },
        template: _.template('<div class="spinner-images"></div><div class="spinner-overlay"></div><div class="spinner-reflection"></div>'),
        itemCanvasTemplate: _.template('<canvas class="spinner-image spinner-image-0" width="<%= width %>" height="<%= height %>"></canvas>'),
        itemBackgroundTemplate: _.template('<img class="spinner-image spinner-image-<%= i %>" src="<%= url %>" />'),
        renderCanvas: function() {
            var self = this;
            this.$el.find(".spinner-images").prepend(self.itemCanvasTemplate(this.model.attributes));
            var canvas = self.$el.find(".spinner-image-0")[0];
            this.context = canvas.getContext("2d");
            _.each(this.model.get("sprite"), function(url, i) {
                self.images = self.images || [];
                self.images.push(new Image);
                self.images[i].onload = function() {};
                self.images[i].src = url;
            });
        },
        renderBackground: function() {
            var self = this;
            _.each(this.model.get("sprite"), function(url, i) {
                self.$el.find(".spinner-images").addClass("spinner-image-sequence").prepend(self.itemBackgroundTemplate({
                    url: url,
                    i: i
                }));
                self.$el.find(".spinner-image-" + i).load(function() {});
            });
            self.$el.find(".spinner-images").append('<div class="spinner-image-sprite spinner-image active"></div>');
        },
        render: function() {
            var self = this;
            this.$el.prepend(this.template());
            this.hasCanvas() ? this.renderCanvas() : this.renderBackground();
        }
    });
    $.easing.easeInOut = function(x, t, b, c, d) {
        return (t /= d / 2) < 1 ? c / 2 * t * t * t * t * t + b : c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    };
})(window.$ || jQuery, window[namespace]);