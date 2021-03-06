// defines the workings of the search system
$("#submit_title_search").click(function(){getSearchResults(); return false;});
$("#search_box").submit(function(){
	getSearchResults();
	return false;
});
$("#get_pond_link").click(function(){
	//pack up the data describing the pond and send it along to the server.
	$.ajax({
		url: "/pond/create/"+$.param({'events':pond}),
		success: function(data){
			$("#pond_url").val("http://festipods.co.uk/#pond_"+data);
			$("#pond_link").fadeIn();
			$("#loading_pond").fadeOut();
		}
	});
	$("#loading_pond").fadeIn();
	return false;
})
var getSearchResults = function(){
	// go get the results from the server
	var searchValue = $('#title_input').val();
	$.getJSON('/search/'+searchValue, parseSearchResults)
	$("#loading").fadeIn('fast');
	return false;
}
var getUUID = function(url){
	return url.split("/")[url.split("/").length-1];
}
var parseSearchResults = function(results){
	// clear the search results
	$("#loading").fadeOut('fast');
	$("#search_results").html("");
	$.each(results, function(i,v){
		appendEventBlock(v, "#search_results");
	});
	attachEventEvents();
};

// har har har at this ambigous function name
var attachEventEvents = function(){
		// now that we have attached all of the events to the dom, attach all of the events that can occur
	$('.to_pond').click(function(){
		var url = $(this).parent().find(".url").val();
		var festival = $(this).parent().find(".festival").val();
		// add the url to the list of bodies in the pond
		pond.push({'url':url, 'festival':festival});
		p5.addBody(url, festival);
		$(this).parent().appendTo('#pond');
		hidePondLink();
		if(pond.length == 0){
			$("#get_pond_link").fadeOut();
			$("#empty_pond").fadeIn();
		}else{
			$("#get_pond_link").fadeIn();
			$("#empty_pond").fadeOut();
		}
		return false;
	});
	$('.from_pond').click(function(){
		var url = $(this).parent().find(".url").val();
		p5.removeBody(url);
		removeUrlFromPond(url);
		$(this).parent().remove();	
		hidePondLink();
		if(pond.length == 0){
			$("#get_pond_link").fadeOut();
			$("#empty_pond").fadeIn();
		}else{
			$("#get_pond_link").fadeIn();
			$("#empty_pond").fadeOut();
		}
		return false;
	});
};

var appendEventBlock = function(data, target){
	var v = data
	// TODO: confirm that the event being returned has not already been added to the pond
	// build the html
	var web = "";
	if(v.website){
		web = "<a href='"+v.website+"' target='new'>web &raquo;</a>";
	}
	var eventHtml = [
		"<div class='event festival_"+v.festival_id+"' id='event_"+v.code+"'>",
			"<div class='name'>"+v.title+" "+web+"</div>",
			"<div class='venue'><span class='bold'>@</span>"+v.venue.name+"</div>",
			"<a href='#' class='to_pond'>add to pond</a>",
			"<a href='#' class='from_pond'>remove from pond</a>",
			"<div class='clear'/>",
			"<input class='url' value='"+getUUID(v.url)+"'>",
			"<input class='festival' value='"+v.festival_id+"'>",
		"</div>"
	].join("\n");
	$(target).append(eventHtml);
	$(".events").removeClass('last');
	$("#pond .events:last, #search_results .events:last").addClass('last');
}
var hidePondLink = function(){
	$("#pond_link").fadeOut();
}