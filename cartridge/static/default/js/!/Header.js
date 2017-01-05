// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define('BE.Views.Header', ['View'], function(View) {
    var Header;
    return Header = (function(_super) {
      __extends(Header, _super);

      function Header() {
        return Header.__super__.constructor.apply(this, arguments);
      }

      Header.prototype.initialize = function() {
        return this.model.on('change:nav', this.nav, this);
      };

      Header.prototype.create = function($el) {
        this.$el = $el;
        return this.delegateEvents();
      };

      Header.prototype.nav = function() {
        var current, previous;
        previous = this.model.previous('nav');
        if (previous == null) {
          previous = 'start';
        }
        current = this.model.get('nav');
        return this.$el.attr('class', 'to-' + current + ' from-' + previous + ' visible');
      };

      Header.prototype.events = {
        'click .mobile-toggle': function(e) {
          e.preventDefault();
          return this.model.set({
            menu: !this.model.get('menu')
          });
        },
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
        'click .reset': function(e) {
          console.log('i started over oooo ', $(e.target), $('.current'));

          /*
          				 * anchor = $(e.target)
          				$('.current').each (index, el) ->
          					el.removeClass('current')
           */
          $('.current').removeClass('current');
          $(e.target).addClass('current');
          this.model.trigger('reset');
          return console.log('done');
        }
      };

      return Header;

    })(View);
  });

}).call(this);