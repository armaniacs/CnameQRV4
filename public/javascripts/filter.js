jQuery(document).ready(function($) {
    function sort_unique(arr) {
	arr = arr.sort();
	var ret = [arr[0]];
	for (var i = 1; i < arr.length; i++) {
	    if (arr[i-1] !== arr[i]) {
		ret.push(arr[i]);
	    }
	}
	return ret;
    }

    $('table.qrv').before(' <label>Country Filter:<select id="c_filter"></select></label><button type="button" id="filter_reset">reset</button">');

    var countries = new Array();
    $('table.qrv td:nth-child(8)').each(function() {
	countries.push($(this).text());
    });

    countries = sort_unique(countries);
    for (var i = 0; i < countries.length; i++) {
	$('#c_filter').append('<option value="'+countries[i]+'">'+countries[i]+'</option>');
    }

    $(document).on('change', '#c_filter', function() {
	var country = $('#c_filter').val();
	$('table.qrv tr').each(function() {
	    var c = $('td:nth-child(8)', this).text();
	    if (c) {
		if (c == country) {
		    $(this).show();
		} else {
		    $(this).hide();
		}
	    }
	});
    });

    $(document).on('click', '#filter_reset', function() {
	$('table.qrv tr').show();
    });
});
