// Copyright andymatthews.net
// packed with http://jsutility.pjoneil.net/
(function($){$.fn.extend({textCounter:function(options){var defaults={count:140,alertAt:20,warnAt:0,target:'',stopAtLimit:false};var options=$.extend(defaults,options);return this.each(function(){var o=options;var $e=$(this);$e.html(o.count);$(o.target).keyup(function(){var cnt=this.value.length;if(cnt<=(o.count-o.alertAt)){$e.removeClass('tcAlert tcWarn');}else if((cnt>(o.count-o.alertAt))&&(cnt<=(o.count-o.warnAt))){$e.removeClass('tcAlert tcWarn').addClass('tcAlert');}else{$e.removeClass('tcAlert tcWarn').addClass('tcWarn');if(o.stopAtLimit)this.value=this.value.substring(0,o.count);}$e.html(o.count-this.value.length);}).trigger('keyup');});}});})(jQuery);