// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define('BE.Views.VideoModal', ['View'], function(View) {
    var VideoModal;
    return VideoModal = (function(_super) {
      __extends(VideoModal, _super);

      function VideoModal() {
        return VideoModal.__super__.constructor.apply(this, arguments);
      }

      VideoModal.prototype.template = _.template('' + '<div>' + '<div class="wrapper">' + '<div class="wrapper-inner">' + '<iframe src="<%= baseUrl %><%= video %>&h=<%= height %>&w=<%= width %>" scrolling="no" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>' + '</div>' + '</div>' + '</div>');

      VideoModal.prototype.youtubeTemplate = _.template('' + '<div>' + '<div class="wrapper">' + '<div class="wrapper-inner">' + '<iframe src="<%= video %>&autoplay=1" scrolling="no" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>' + '</div>' + '</div>' + '</div>');

      VideoModal.prototype.initialize = function() {
        this.model.on('create', this.create, this);
        this.model.on('change:state', this.state, this);
        return this.model.on('show', this.show, this);
      };

      VideoModal.prototype.create = function($el) {
        this.$el = $el;
        return this.delegateEvents();
      };

      VideoModal.prototype.state = function() {
        var current, previous;
        current = this.model.get('state');
        previous = this.model.previous('state');
        return this.$el.removeClass(previous).addClass(current);
      };

      VideoModal.prototype.show = function() {
        var height, idealheight, maxheight, parent, width, win;
        parent = $('.video-player');
        win = $(window);
        width = win.width();
        idealheight = width * 9 / 16;
        maxheight = win.height() - 140;
        if (idealheight > maxheight) {
          height = maxheight / 2;
          width = maxheight * 8 / 9;
        } else {
          height = idealheight / 2;
        }
        this.model.set({
          height: height,
          width: width
        });
        if (/youtube.com/.exec(this.model.get('video'))) {
          parent.append(this.youtubeTemplate(this.model.attributes));
        } else {
          parent.append(this.template(this.model.attributes));
        }
        this.$el.find('.video-player').height(height).find('.wrapper').width(width);
        return this.model.once('hide', (function(_this) {
          return function() {
            return _this.$el.find('.video-player').remove();
          };
        })(this));
      };

      VideoModal.prototype.events = {
        'click .hide': function(e) {
          e.preventDefault();
          return this.model.trigger('hide');
        },
        'click .overlay': function(e) {
          e.preventDefault();
          return this.model.trigger('hide');
        }
      };

      return VideoModal;

    })(View);
  });

}).call(this);
