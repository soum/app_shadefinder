// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define('BE.Views.Page', ['$', 'UI', 'View'], function($, UI, View) {
    var Browser, PageView;
    Browser = UI.Browser;
    return PageView = (function(_super) {
      __extends(PageView, _super);

      function PageView() {
        return PageView.__super__.constructor.apply(this, arguments);
      }

      PageView.prototype.initialize = function() {
        this.model.on('create', this.create, this);
        this.model.on('change:state', this.state, this);
        this.model.on('change:menu', this.menu, this);
        return this.model.on('change:page', this.page, this);
      };

      PageView.prototype.create = function($el) {
        this.$el = $el;
        this.body = $('body');
        this.delegateEvents(this.events);
        return Browser.listen(this.body[0], 'AnimationEnd', (function(_this) {
          return function(e) {
            return _this.model.set({
              animation: e.animationName
            });
          };
        })(this));
      };

      PageView.prototype.state = function() {
        var current, previous;
        previous = this.model.previous('state');
        if (previous == null) {
          previous = 'start';
        }
        current = this.model.get('state');
        if (this.body) {
          return this.body.attr('class', 'show from-' + previous + ' to-' + current);
        }
      };

      PageView.prototype.menu = function() {
        if (this.model.get('menu')) {
          return $('html').addClass('menu-open').removeClass('menu-closed');
        } else {
          return $('html').addClass('menu-closed').removeClass('menu-open');
        }
      };

      PageView.prototype.page = function() {
        var current, previous;
        previous = this.model.previous('page');
        if (previous == null) {
          previous = 'start';
        }
        current = this.model.get('page');
        return this.$el.attr('class', 'from-page-' + previous + ' to-page-' + current);
      };

      PageView.prototype.events = {
        'click .navigate': function(e) {
          var anchor;
          e.preventDefault();
          anchor = $(e.currentTarget);
          return this.model.navigate(anchor.data('to'), anchor.data('direction'));
        },
        'click .back': function(e) {
          e.preventDefault();
          return this.model.back();
        },
        'click .close': function(e) {
          e.preventDefault();
          return this.model.trigger('close');
        },
        'click .reset': function() {
          return this.model.trigger('reset');
        },
        'click .video': function(e) {
          var video;
          video = $(e.currentTarget).data('video');
          return this.model.trigger('video', video);
        },
        'click .print': function(e) {
          e.preventDefault();
          return window.print();
        }
      };

      return PageView;

    })(View);
  });

}).call(this);
