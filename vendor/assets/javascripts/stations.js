$(document).ready(function() {
  
  var maxDaysToRenderIntoChart = 200;
  
  var renderDownTimePercentage = function(liftId, downTime) {
  
    var $chartDescription = $("#downTimePercentageDescription_" + liftId);
          
    data = [ 
      { label: 'uptime', data: maxDaysToRenderIntoChart * 86400, color: '#5AC364' }, 
      { label: 'downtime', data: downTime <= 0 ? 1 : downTime, color: '#CF335A' }
    ];
    
    $.plot($("#downTimePercentage_" + liftId), data, {
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
    $chartDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift " + hoursDownTime + " Stunden defekt.");
  };
  
  var renderDownTimeAbsolute = function(liftId, downTimeEvents) {
  
    var $chartCanvas = $("#downTimeAbsolute_" + liftId),
          $chartDescription = $("#downTimeAbsoluteDescription_" + liftId),
          downTimeCount = downTimeEvents.length,
          tooltipId = 'downTimeAbsolute_tooltip' + liftId;

    
    var data = [],
          timeRanges = [];
    
    $.each(downTimeEvents, function(index, event) {
      data.push( [index, event.duration] );
      var timeStampWithoutTimeZone = event.timestamp.substring(0, event.timestamp.length-1);
      var startDate = Date.parse(timeStampWithoutTimeZone);
            endDate = Date.parse(timeStampWithoutTimeZone).add(event.duration).seconds();      
      timeRanges[index] = startDate.toString('dd.MM.yyyy HH:mm') + ' - ' + endDate.toString('dd.MM.yyyy HH:mm')
    });
    
    var showChartTooltip = function(x, y, contents) {
        $tooltip = $('#' + tooltipId);
        if($tooltip.length > 0){
          $tooltip.offset({top: y + 5, left: x + 5 });
          $tooltip.html(contents);
        } else {
          $('<div id="' + tooltipId + '">' + contents + '</div>').css( {
              position: 'absolute',
              top: y + 5,
              left: x + 5,
              border: '1px solid #fdd',
              padding: '2px',
              'background-color': '#fee',
              opacity: 0.80
          }).appendTo("body");
        }
    }    
    
    $.plot($chartCanvas, [ data ], {
      series: {
        color: '#CF335A',
        bars: { show: true },
        stroke: {
          width: 1
        },
      },
      grid: {
        hoverable: true,
        markings: function (axes) {
          var markings = [];
          
          var step = axes.yaxis.max / (axes.yaxis.max / 7200);
          for (var y = Math.floor(axes.yaxis.min); y < axes.yaxis.max; y += step)
            markings.push({ yaxis: { from: y, to: y + (step / 2) } });
          return markings;
        },
        borderWidth: 1,
        borderColor: '#A0A0A0'
      },
      yaxis: {
        tickFormatter: function(val, axis) {
          var hours = Math.floor(val / 3600);
          var minutes = Math.floor( (val % 3600) / 60 );
          if(hours < 10) {
            hours = '0' + hours;
          }
          if(minutes < 10) {
            minutes = '0' + minutes;
          }
          
          return hours+":"+minutes+" h";
        },
        tickLength: 0
      },
      xaxis: {
        show: false        
      }
    });
    
    var storedIndex;
    $($chartCanvas).bind("plothover", function (event, pos, item) {
      if(item) {
        if(item.dataIndex != storedIndex) {
          storedIndex = item.dataIndex;
          showChartTooltip(item.pageX, item.pageY, timeRanges[storedIndex]);
        }
      } else {
        $('#' + tooltipId).remove();
        storedIndex = null;
      }
    });
    
    $chartDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen hatte dieser Lift " + downTimeCount + " Defekte.");  
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