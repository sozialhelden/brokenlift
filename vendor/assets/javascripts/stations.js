$(document).ready(function() {
  
  var maxDaysToRenderIntoChart = 200;
  
  var renderDownTimePercentage = function(liftId, downTime) {
  
    var $graphDescription = $("#downTimePercentageDescription_" + liftId);
          
    data = [ 
      { label: 'uptime', data: maxDaysToRenderIntoChart * 86400, color: '#5AC364' }, 
      { label: 'downtime', data: downTime <= 0 ? 1 : downTime, color: '#CF335A' }
    ];
    
    $.plot($("#downTimePercentage_" + liftId), data,
    {
      series: {
        pie: {
          show: true,
          radius: 1,
          stroke: {
            color: 'transparent',
            width: 0
          },
          label: {
              show: true,
              radius: 3/5,
              formatter: function(label, series){
                  return '<div style="font-size:12pt;color:#505050;font-weight:bold;color:white;padding: 1px 5px;">'+Math.round(series.percent)+'%</div>';
              },
              background: { opacity: 0.5, color: '#999' }
          }
        }
      },
      legend: {
          show: false
      }
    });
     
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