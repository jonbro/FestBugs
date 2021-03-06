// lets load all the processing stuff over ajax and execute it once it has all been loaded
var toLoad = ["js/sheet.json", "js/search_system.js", "js/processing-24accf5.min.js", "js/Box2dWeb-2.1.a.3.min.js", "js/ParticleSystem.pjs", "js/body.pjs", "js/pjs_chars.pjs", "js/seedrandom.js"];
var mute = false;
var p5;
var pond = Array(); // contains a list of the bugs that are in the current pond
var removeUrlFromPond = function(url){
  for (var i = pond.length - 1; i >= 0; i--) {
    if(pond[i].url == url){
      pond.splice(i, 1);
      return;
    }
  };
}
var emptyPond = function(){
  pond = Array();
  $("#pond .event").remove();  
  hidePondLink();
  $("#get_pond_link").fadeOut();
  $("#empty_pond").fadeIn();
};
var loadPondFromUrl = function(){
  // first, empty the pond
  // extract the pond id from the url
  var id = document.location.hash.split("_")[document.location.hash.split("_").length-1];
  // fire off a json load
  $.getJSON('/pond/'+id, function(data){
    $.each(data, function(i,v){
      pond.push({'url':v.url, 'festival':v.festival});
      p5.addBody(v.url, v.festival);
      $.getJSON('/event/'+v.url, function(edata){
          appendEventBlock(edata, "#pond");
          attachEventEvents();
          $("#empty_pond").fadeOut();
      });
    });
  });
};
var checkForLoaded = function()
{
  if(document.location.hash){
    loadPondFromUrl();
  }
}
$(document).ready(function(){
  var synth = $("#audio_player");
  // wait for the canvas to load before kicking off the ajax stuff
  $(window).load(function(){
    // before setting up processing, check for webgl
    var contextNames = ['experimental-webgl', 'webgl', 'webkit-3d'];
    var noGl = true;
    for(var i = 0; i < contextNames.length; i++){
      try { //Needed for unsupported browsers, otherwise it gets caught up on the next line
        var context = document.getElementById("test-canvas").getContext(contextNames[i]);
        if(context) {
          noGl = noGl && false;
        }
      }
      catch(e) {
      }
    }
    if(noGl){
      document.location = "/noGl.html";
    }
    $("#test-canvas").remove();
    var loadCount = 0;
    var toExecute = new Array();
    // this gets kicked off after all the files have been loaded
    var downloadComplete = function(){
      loadCount++;

      if (loadCount >= toLoad.length){
        var processingCode = "";
        // concat all of the processing code together
        $.each(toExecute, function(i, v){
          if(v){
            processingCode += v;
          }
        });
        // setup the processing context with the source code
        // console.log(document.getElementById("processing-canvas").getContext
        // console.log($("#processing-canvas").get(0).getContext());
        p5 = new Processing(document.getElementById("processing-canvas"), processingCode);        
        // check to see if there is a pond in the url, and if so, fire off the requests that will give us the data about what to include in the pond
      }
    }
    // when the window resizes, resize the processing canvas to fit
    $(this).resize(function(){
      var left = Math.max(0, ($(window).width()-284)/2-400);
      $("#processing-canvas").css({left:left})
    });
    // fire off a whole pile of loads
    $.each(toLoad, function(i, v){
      // split the file name on the ending
      var end = v.split(".");
      end = end[end.length-1];

      // javascript files don't matter the order
      // so we will execute them as they come in
      if(end == "js"){
        $.ajax({
          url: v,
          dataType: 'script',
          success: function(data){
            downloadComplete();
          }
        });
      }else if(end == "pjs"){
        $.ajax({
          url: v,
          dataType: 'text',
          success: function(data){
            toExecute[i] = data;
            downloadComplete();
          }
        });
      }else if(end == "json"){
        $.ajax({
          url: v,
          dataType: 'json',
          success: function(data){
            ssData = data;
            downloadComplete();
          }
        });        
      }
    });      
  });
});