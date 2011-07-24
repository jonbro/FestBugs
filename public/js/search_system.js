// defines the workings of the search system
$("#submit_title_search").click(function(){
	// go get the results from the server
	console.log("test");
	var searchValue = $('#title_input').val();
	$.getJSON('/search/'+searchValue, parseSearchResults)
	return false;
});


var parseSearchResults = function(results){
	console.log(results);
	// clear the search results
	$("#search_results").html("");
	$.each(results, function(i,v){
		// build the html
		var eventHtml = [
				"<div class='event festival_"+v.festival_id+"' id='event_"+v.code+"'>",
				"<div class='name'>"+v.title+"</div>",
				"<div class='venue'><span class='bold'>@</span>"+v.venue.name+"</div>",
			"</div>"
		].join("\n");
		$("#search_results").append(eventHtml);
	});
};