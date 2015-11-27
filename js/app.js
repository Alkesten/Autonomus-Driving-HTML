var main = function() {
	var active = false;
	var lastClicked = '';

	$('.button-manual').click(function(){
		$('.button-manual').removeClass('active');

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

	$( "ul.sortable" ).sortable({
		group: 'sortable'
	});

	$( ".draggable" ).draggable({
		connectToSortable: ".sortable",
		helper: "clone",
		greedy: 'true',
		revert: "invalid"

	});

	$( "ul, li" ).disableSelection();
};

$(document).ready(main);