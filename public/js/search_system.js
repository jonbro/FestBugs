// defines the workings of the search system
$("#submit_title_search").click(function(){
	// go get the results from the server
	console.log("test");
	var searchValue = $('#title_input').val();
	$.getJSON('/search/'+searchValue, parseSearchResults)
	return false;
});


var parseSearchResults = function(results){
	$.each(results, function(i,v){
		// build the html
		var eventHtml = [
			"<div class='event festival_"+v.festival_id+"'>",
				"<div class='name'>"+v.title+"</div>",
				"<div class='venue'><span class='bold'>@</span>"+v.venue.name+"</div>",
				"<div class='date'>August 7th</div>",
				"<div class='time'>1pm - 6pm</div>",
			"</div>"
		].join("\n");
		$("#event_list").append(eventHtml);
	});
};