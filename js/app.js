var main = function() {
	var active = false;
	var lastClicked = '';

	$('.button').click(function(){
		$('.button').removeClass('active');

		if(active==true && lastClicked==$(this).attr('id')) {
			active=false;
			lastClicked='';
			$(this).removeClass('active');
		} else {
			active=true;
			lastClicked=$(this).attr('id');
			$(this).addClass('active');	
		}
	});

	$('ul.tabs li').click(function(){
		var tabId = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('active');
		$('.tab-content').removeClass('active');

		$(this).addClass('active');
		$("#"+tabId).addClass('active');
	})
};

$(document).ready(main);