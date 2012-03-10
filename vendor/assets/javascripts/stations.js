// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  
  $('#liftsList li').each(function(index, value) {
    var liftId = $(this).data('lift_id');
    BROKENLIFT.api.fetchResource('lifts/' + liftId, function(data){
      $graphCanvas = $("#graph1_" + liftId);
      r = Raphael($graphCanvas.attr('id'));
      r.piechart($graphCanvas.width() / 2, $graphCanvas.height() / 2, $graphCanvas.width() * 0.4, [55, 20, 13, 32, 5, 1, 2, 10]);
      console.log(data);
    });    
  });
});
