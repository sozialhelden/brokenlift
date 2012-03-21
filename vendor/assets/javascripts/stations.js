$(document).ready(function() {
  
  var maxDaysToRenderIntoChart = 200;
  
  var renderDownTimePercentage = function(liftId, downTime) {
  
    var $chartDescription = $("#downTimePercentageDescription_" + liftId);
          
    data = [ 
      { label: 'uptime', data: maxDaysToRenderIntoChart * 86400, color: '#8EBC7A' }, 
      { label: 'downtime', data: downTime <= 0 ? 1 : downTime, color: '#CF335A' }
    ];
    
    $.plot($("#downTimePercentage_" + liftId), data, {
      series: {
        pie: {
          show: true,
          radius: 0.9,
          stroke: {
            color: 'transparent',
            width: 0
          },
          label: {
              show: true,
              radius: 3/5,
              formatter: function(label, series){
                  return '<div style="font-size:12pt;color:#505050;font-weight:bold;color:white;text-shadow: #000 1px 1px 3px;padding: 1px 5px;">'+Math.round(series.percent)+'%</div>';
              }
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
          tooltipId = 'downTimeAbsolute_tooltip' + liftId;

    
    var data = [],
          timeRanges = [];
          
          
    downTimeEvents = $.map(downTimeEvents, function (event) { 
      if(event.duration > 0){
        return event;
      }
    });
    
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
              'font-weight': 'bold',
              'background-color': '#fee',
              opacity: 0.90
          }).appendTo("body");
        }
    }    
    
    $.plot($chartCanvas, [ data ], {
      series: {
        color: 'transparent',
        bars: { show: true, barWidth: 0.75,  fillColor: { colors: [ '#CE1E4A', '#EF8FA7' ] } }
      },
      grid: {
        hoverable: true,
        borderWidth: 0,
        backgroundColor: { colors: [ '#FFF', '#EEE' ] }      
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
        }
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
    
    $chartDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen hatte dieser Lift " + downTimeEvents.length + " Defekte.");  
  };
  
  var renderDownTimeHistory = function(liftId, dailyStatusHistory) {
  
    var $chartCanvas = $("#downTimeHistory_" + liftId),
          $chartDescription = $("#downTimeHistoryDescription_" + liftId);

    var data = [],
          daysNotWorking = 0,
          historySize = dailyStatusHistory.length;
         
    $.each(dailyStatusHistory, function(index, event) {      
      data.push([historySize - index, event.is_working ? 0 : 1]);
      if(!event.is_working) {
        daysNotWorking++;
      }
    });
    
    $.plot($chartCanvas, [ data ], {
      series: {
        color: '#CF335A',
        lines: { show: true, fill: true, fillColor: '#ECADBD'  },
        stroke: {
          width: 1
        },
      },
      grid: {
        hoverable: true,
        show: true,
        borderWidth: 0,
        backgroundColor: { colors: [ '#FFF', '#EEE' ] }
      },
      yaxis: {
        show: false
      },
      xaxis: {
        show: true,
        tickFormatter: function(val, axis) {    
          return (maxDaysToRenderIntoChart - val).days().ago().toString('dd.MM.yyyy');
        },        
      }
    });
     
    $chartDescription.html("In den letzten " + maxDaysToRenderIntoChart + " Tagen war dieser Lift an " + daysNotWorking + " Tagen defekt.");  
  };
  
  $('#liftsList li').each(function(index, value) {
    if(index != 0) {
      $(this).children('div').hide();
    } else {
      $(this).addClass('selected');
    }
    var liftId = $(this).data('lift_id');

    BROKENLIFT.api.fetchResource('lifts/' + liftId + '/statistics.json/?days=200', function(data){
      var lift = data.lift;

      renderDownTimePercentage(liftId, lift.downTime);
      renderDownTimeAbsolute(liftId, lift.downTimeEvents);
      renderDownTimeHistory(liftId, lift.dailyStatusHistory);
    });    
  });
  
});