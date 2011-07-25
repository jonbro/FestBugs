// lets load all the processing stuff over ajax and execute it once it has all been loaded
var toLoad = ["js/sheet.json", "js/search_system.js", "js/processing.js", "js/Box2dWeb-2.1.a.3.js", "js/body.pjs", "js/pjs_chars.pjs"];
var mute = false;
    var p5;
$(document).ready(function(){
  var synth = $("#audio_player");
  // wait for the canvas to load before kicking off the ajax stuff
  $(window).load(function(){
    var loadCount = 0;
    var toExecute = new Array();
    // this gets kicked off after all the files have been loaded
    var downloadComplete = function(){
      loadCount++;
      console.log(loadCount, toLoad.length);

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
        console.log($("canvas").get(0));
        console.log(processingCode);
        p5 = new Processing(document.getElementById("processing-canvas"), processingCode);
      }
    }
    // when the window resizes, resize the processing canvas to fit
    $(this).resize(function(){
      p5.size($(window).width()-284, $(window).height());
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
            console.log(v);
            downloadComplete();
          }
        });
      }else if(end == "pjs"){
        $.ajax({
          url: v,
          dataType: 'text',
          success: function(data){
            console.log(v);
            toExecute[i] = data;
            downloadComplete();
          }
        });
      }else if(end == "json"){
        $.ajax({
          url: v,
          dataType: 'json',
          success: function(data){
            console.log(v);
            ssData = data;
            downloadComplete();
          }
        });        
      }
    });      
  });
});