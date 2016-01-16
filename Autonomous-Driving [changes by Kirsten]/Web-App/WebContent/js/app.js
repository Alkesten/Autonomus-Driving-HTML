var main = function() {
	var active = false;
	var lastClicked = '';

	$('.manual-button').click(function() {
		$('.manual-button').removeClass('active');

		if (active == true && lastClicked == $(this).attr('id')) {
			active = false;
			lastClicked = '';
			$(this).removeClass('active');
		} else {
			active = true;
			lastClicked = $(this).attr('id');
			$(this).addClass('active');
		}
	});

	$('.queue-add').click(function() {
		$('.queue-add').toggleClass('active');
		$('.queue-options').toggleClass('active');
		$('.queue-options').toggleClass('transform');
	});

	$('.add-instruction')
			.click(
					function() {
						$('.queue-add').toggleClass('active');
						$('.queue-options').toggleClass('active');
						$('.queue-options').toggleClass('transform');

						var instruction = $(this).text();
						if (instruction == 'Turn Left') {
							$(
									'<li><i class="fa fa-hand-o-left"></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						} else if (instruction == 'Turn Right') {
							$(
									'<li><i class="fa fa-hand-o-right"></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						} else if (instruction == 'Stop') {
							$(
									'<li><i class="fa fa-hand-grab-o"></i></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						} else if (instruction == 'Forward') {
							$(
									'<li><i class="fa fa-hand-o-up"></i></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						} else if (instruction == 'Backward') {
							$(
									'<li><i class="fa fa-hand-o-down"></i></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						} else {
							$(
									'<li><i class="fa fa-car"></i></i>'
											+ instruction
											+ '<button class="delete-button right">x</button></li>')
									.appendTo('.queue');
						}
					});

	$('ul.tabs li').click(function() {
		var tabId = $(this).attr('data-tab');
		$('ul.tabs li').removeClass('active');
		$('.tab-content').removeClass('active');

		$(this).addClass('active');
		$("#" + tabId).addClass('active');
	})

	$('ul.queue').sortable();
};

$(document).ready(main);
$(document).on('click', '.delete-button', function() {
	$(this).parent().remove();
});