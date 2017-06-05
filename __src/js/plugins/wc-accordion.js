/**
 * Title:
 * Welance Craft wc-accordion Pluging
 *
 * Description:
 * Ultra simple wc-accordion (and opinionated) jquery plugin that
 * only switched classes to pre-existing ones ("wc-accordion-title" and "wc-accordion-content")
 *
 * "wc-accordion-title" becomes "wc-accordion-title--active" (and vice versa)
 * "wc-accordion-content" becomes "wc-accordion-content--active" (and vice versa)
 *
 *
 * Usage:
 * HTML:
 * <div class="whatever-wrap">
 *  <div class="wc-accordion-title">title</div>
 *  <div class="wc-accordion-content">your content here</div>
 * </div>
 *
 * JS:
 * $('whatever-wrap').wc-accordion();
 *
 * Author: enrico <enrico@welance.com>
 *
 */
import $ from 'jquery';

$.fn.wc_accordion = function() {
  let $title = this.find(".wc-accordion-title");
  let $first_title = this.find(".wc-accordion-title").first();
  let $content = this.find(".wc-accordion-content");

  let $first_element = this.find(".wc-accordion-content").first();

  //open first content
  $first_title.addClass('wc-accordion-title--active');
  $first_title.next().addClass('wc-accordion-content--active');

  $title.on("click", function(ev){
    $title.removeClass('wc-accordion-title--active');
    $content.removeClass('wc-accordion-content--active');

    $(ev.target).addClass('wc-accordion-title--active');
    $(ev.target).next().addClass('wc-accordion-content--active');

  });
};
