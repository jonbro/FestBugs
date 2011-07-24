// defines the workings of the search system
$("#submit_title_search").click(getSearchResults);
$("#search_box").submit(function(){
	getSearchResults();
	return false;
});

var getSearchResults = function(){
	// go get the results from the server
	var searchValue = $('#title_input').val();
	$.getJSON('/search/'+searchValue, parseSearchResults)
	return false;
}

var parseSearchResults = function(results){
	// clear the search results
	$("#search_results").html("");
	$.each(results, function(i,v){
		// TODO: confirm that the event being returned has not already been added to the pond
		// build the html
		var web = "";
		if(v.website){
			web = "<a href='"+v.website+"'>web &raquo;</a>";
		}
		var last = false;
		if(i==results.length-1){
			last = true;
		}
		var eventHtml = [
			"<div class='event festival_"+v.festival_id+(last?" event_last":"")+"' id='event_"+v.code+"'>",
				"<div class='name'>"+v.title+" "+web+"</div>",
				"<div class='venue'><span class='bold'>@</span>"+v.venue.name+"</div>",
				"<a href='#' class='to_pond'>add to pond</a>",
			"</div>"
		].join("\n");
		$("#search_results").append(eventHtml);
	});
	// now that we have attached all of the events to the dom, attach all of the events that can occur
	$('.to_pond').click(function(){
		p5.addBody();
		// move the element into the pond list
		$(this).parent().appendTo('#pond')
	});
};