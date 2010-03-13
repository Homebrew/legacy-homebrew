(function($) {
	$(function() {
		$('pre.overflow').bind('mouseover', function() {
			$(this).css({
				'overflow' : 'auto',
				'padding-bottom' : '8px'
			});
		}).bind('mouseout', function() {
			$(this).css({
				'overflow' : 'hidden',
				'padding-bottom' : '23px'
			});
		}).trigger('mouseout');
	});
})(jQuery);
