(function($) {
  var cwic_sticky_header = {
    options: null,
    toStick: null,
    stickPosition: null,
    scrollViewport: null,
    nowSticky: false,
    init: function(toStick, stickPosition, options) {
      this.options = $.extend({
        before_swap: function(){},
        after_swap: function(){},
      }, options || {});
      this.toStick = toStick;
      this.stickPosition = stickPosition;
      this.scrollViewport = $('#content-area');
      this.addScrollbarWidth();
      this.bindEvents();
    },
    bindEvents: function() {
      var _this = this;
      this.scrollViewport.on('scroll.cwic_sticky', $.throttle(200, function() { _this.stickyOnScroll.call(_this); }));
    },
    stickyOnScroll: function() {
      var viewportOffset = parseFloat(this.scrollViewport.offset().top);
      var toStickOffset = parseFloat(this.toStick.offset().top);
      this[(toStickOffset < viewportOffset) ? 'stick' : 'unStick']();
    },
    stick: function() {
      if(!this.nowSticky) {
        this.options.before_swap(this.toStick);
        this.toStick.contents().appendTo(this.stickPosition);
        this.options.after_swap(this.stickPosition);
        this.nowSticky = true;
      }
    },
    unStick: function() {
      if(this.nowSticky) {
        this.options.before_swap(this.stickPosition);
        this.stickPosition.contents().appendTo(this.toStick);
        this.options.after_swap(this.toStick);
        this.nowSticky = false;
      }
    },
    addScrollbarWidth: function() {
      this.stickPosition.css('marginRight', APP.util.getScrollbarWidth() + 'px');
    }
  };

  $.fn.cwicStickyHeader = function(options) {
    var elems = $(this).not('.cwic-sticky');
    elems.each(function() {
      var header = $(this);
      var stickDiv = $(header.data('stick-to'));
      cwic_sticky_header.init($(this), stickDiv, options);
    });
  };
})(jQuery);
