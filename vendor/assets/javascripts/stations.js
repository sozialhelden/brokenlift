  
$(document).ready(function(){
  // @todo enhance api call to pass only events back which are over the treshold
  var maxDaysToRenderIntoChart = 200;  
  
  // @todo add api call to get precalculated graph data (process the event history already on the server side)
  var transformEventsToChartData = function(events) {
    
    var ignoreAllEventsLowerThanThisDate = new Date() - (maxDaysToRenderIntoChart * 86400 * 1000);

    var dataSeries = [],
          sumDownTime = 0.
          downTimeDurations = [],
          dailyDownTimeStatus = [];

    $.each(events, function(index, event) {
      var dataSet = {
        date: new Date(event.timestamp),        
        isWorking: event.is_working        
      };
      
      dataSet.daysFromToday = Math.round((new Date() - dataSet.date) / (86400 *1000),2);
      
      if(dataSet.date >= ignoreAllEventsLowerThanThisDate) {
        dataSeries.push(dataSet);
      }      
    });

    $.each(dataSeries, function(index, dataSet){
      if(dataSeries[index - 1]){        
        dataSet.durationInSeconds = (dataSeries[index - 1].date - dataSet.date) / 1000;
      } else {
        dataSet.durationInSeconds = ((new Date()).getTime() - dataSet.date) / 1000;
      }

      if(! dataSet.isWorking){        
        sumDownTime += dataSet.durationInSeconds;
        downTimeDurations.push(dataSet.durationInSeconds);        
      }

      dailyDownTimeStatus[dataSet.daysFromToday] = dataSet.isWorking ? 0 : 1;
    });
    
    // @todo find a better way to create a historical downtime chart
    var lastStatus = 0;
    for(var i = 0; i < maxDaysToRenderIntoChart; i++) {
      if(typeof(dailyDownTimeStatus[i]) === "undefined"){
        dailyDownTimeStatus[i] = lastStatus;
      } else{
        lastStatus = dailyDownTimeStatus[i];
      }
    }

    return {
      dataSeries: dataSeries,
      sumDownTime: sumDownTime,
      downTimeDurations: downTimeDurations,
      dailyDownTimeStatus: dailyDownTimeStatus
    };
  };
  
  var renderDownTimePercentage = function(liftId, chartData) {
  
    var $graphCanvas = $("#downTimePercentage_" + liftId),
          $graphDescription = $("#downTimePercentageDescription_" + liftId),
          downTime = chartData.sumDownTime;

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
  
  var renderDownTimeAbsolute = function(liftId, chartData) {
  
    var $graphCanvas = $("#downTimeAbsolute_" + liftId),
          $graphDescription = $("#downTimeAbsoluteDescription_" + liftId),
          downTime = chartData.sumDownTime;

    var r = Raphael($graphCanvas.attr('id'));    
    var barChart = r.barchart(
      0, 
      0, 
      $graphCanvas.width(), 
      $graphCanvas.width(),    
      [chartData.downTimeDurations]
    );

    barChart.bars[0].attr('fill','#CF335A');
     
    hoursDownTime = Math.round((downTime / 3600), 2);
    $graphDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift " + hoursDownTime + " Stunden defekt.");  
  };
  
  var renderDownTimeHistory = function(liftId, chartData) {
  
    var $graphCanvas = $("#downTimeHistory_" + liftId),
          $graphDescription = $("#downTimeHistoryDescription_" + liftId),
          downTime = chartData.sumDownTime;

    var r = Raphael($graphCanvas.attr('id'));    
    var barChart = r.barchart(
      0, 
      0, 
      $graphCanvas.width(), 
      $graphCanvas.height(),    
      [chartData.dailyDownTimeStatus]
    );

    barChart.bars[0].attr('fill','#CF335A');
     
    hoursDownTime = Math.round((downTime / 3600), 2);
    $graphDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift " + hoursDownTime + " Stunden defekt.");  
  };
  
  $('#liftsList li').each(function(index, value) {
    var liftId = $(this).data('lift_id');

    BROKENLIFT.api.fetchResource('lifts/' + liftId, function(data){    
      var lift = data.lift,
            events = lift.events;

      var chartData = transformEventsToChartData(events);
      renderDownTimePercentage(liftId, chartData);
      renderDownTimeAbsolute(liftId, chartData);
      renderDownTimeHistory(liftId, chartData);
    });    
  });
  
});