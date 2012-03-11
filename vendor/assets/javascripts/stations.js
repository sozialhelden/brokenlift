$(document).ready(function() {
  
  var maxDaysToRenderIntoChart = 200;
  
  var renderDownTimePercentage = function(liftId, downTime) {
  
    var $graphCanvas = $("#downTimePercentage_" + liftId),
          $graphDescription = $("#downTimePercentageDescription_" + liftId);

    var r = Raphael($graphCanvas.attr('id'));
    
    var pieChart = r.piechart(
      $graphCanvas.width() / 2, 
      $graphCanvas.height() / 2, 
      $graphCanvas.width() * 0.4, 
      [maxDaysToRenderIntoChart * 86400, downTime <= 0 ? 1 : downTime]
     );

    var seriesUpTime = pieChart.series[0],
          seriesDownTime = pieChart.series[1];

    seriesUpTime.attr('fill','#5AC364');
    seriesUpTime.attr('stroke','transparent');
    seriesDownTime.attr('fill','#CF335A');     
    seriesDownTime.attr('stroke','transparent');     
     
    hoursDownTime = Math.round((downTime / 3600), 2);
    $graphDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift " + hoursDownTime + " Stunden defekt.");
  };
  
  var renderDownTimeAbsolute = function(liftId, downTimeEvents) {
  
    var $graphCanvas = $("#downTimeAbsolute_" + liftId),
          $graphDescription = $("#downTimeAbsoluteDescription_" + liftId),
          downTimeCount = downTimeEvents.length;
    
    var chartData = [];
    $.each(downTimeEvents, function(index, event) {
      chartData.push(event.duration);      
    });
    var r = Raphael($graphCanvas.attr('id'));    
    var barChart = r.barchart(
      0, 
      0, 
      $graphCanvas.width(), 
      $graphCanvas.width(),    
      [chartData]
    );

    barChart.bars[0].attr('fill','#CF335A');
    
    $graphDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen hatte dieser Lift " + downTimeCount + " Defekte.");  
  };
  
  var renderDownTimeHistory = function(liftId, dailyStatusHistory) {
  
    var $graphCanvas = $("#downTimeHistory_" + liftId),
          $graphDescription = $("#downTimeHistoryDescription_" + liftId);

    var chartData = [],
          daysNotWorking = 0;
    $.each(dailyStatusHistory, function(index, event) {
      chartData.push(event.is_working ? 0 : 1);
      if(!event.is_working) {
        daysNotWorking++;
      }
    });

    var r = Raphael($graphCanvas.attr('id'));    
    var barChart = r.barchart(
      0, 
      0, 
      $graphCanvas.width(), 
      $graphCanvas.height(),    
      [chartData]
    );

    barChart.bars[0].attr('fill','#CF335A');
     
    $graphDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift an " + daysNotWorking + " Tagen defekt.");  
  };
  
  $('#liftsList li').each(function(index, value) {
    var liftId = $(this).data('lift_id');

    BROKENLIFT.api.fetchResource('lifts/' + liftId + '/statistics.json/?days=200', function(data){
      var lift = data.lift;

      renderDownTimePercentage(liftId, lift.downTime);
      renderDownTimeAbsolute(liftId, lift.downTimeEvents);
      renderDownTimeHistory(liftId, lift.dailyStatusHistory);
    });    
  });
  
});