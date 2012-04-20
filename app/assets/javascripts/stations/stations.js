$(document).ready(function() {
  var maxDaysToRenderIntoChart = 200,
        pluralize = function(value, singularString, pluralString) {
          return value == 1 ? singularString : pluralString;
        },
        partialDescriptionString = (function(maxDays) {
            return maxDays == 1 ?
              "<p>Am<br/> <span class=\"bold\">gestrigen Tag</span>" :
              "<p>In den letzten<br/> <span class=\"bold\">" + maxDaysToRenderIntoChart + " Tagen</span>";
        })(maxDaysToRenderIntoChart);

  var renderDownTimePercentage = function(liftId, downTime) {

    var $chartDescription = $("#downtime-percentage-description-" + liftId);

    data = [
      { label: 'uptime', data: maxDaysToRenderIntoChart * 86400, color: '#8EBC7A' },
      { label: 'downtime', data: downTime <= 0 ? 1 : downTime, color: '#CF335A' }
    ];

    $.plot($("#downtime-percentage-" + liftId), data, {
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

    var hoursDownTime = Math.round((downTime / 3600), 2),
          hours = pluralize(hoursDownTime, "Stunde", "Stunden");
    
    $chartDescription.html(partialDescriptionString + "<br/> war dieser Lift<br/> " + hoursDownTime + " " + hours + "<br/><span class=\"bolder\">defekt</span></p>");
  };

  var renderDownTimeAbsolute = function(liftId, downTimeEvents) {

    var $chartCanvas = $("#downtime-absolute-" + liftId),
          $chartDescription = $("#downtime-absolute-description-" + liftId),
          tooltipId = 'downtime-absolute-tooltip-' + liftId;


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

    var storedIndex,
          defectsCount = downTimeEvents.length,
          defects = pluralize(defectsCount, "Defekt", "Defekte");
          
    console.log()
          
    $chartCanvas.bind("plothover", function (event, pos, item) {
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
    
    $chartDescription.html(partialDescriptionString + "<br/> hatte dieser Lift<br/><span class=\"bolder\">" + defectsCount + " " + defects + "</span></p>");
  };

  var renderDownTimeHistory = function(liftId, dailyStatusHistory) {

    var $chartCanvas = $("#downtime-history-" + liftId),
          $chartDescription = $("#downtime-history-description-" + liftId);

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
    
    var days = pluralize(daysNotWorking, "Tag", "Tagen");

    $chartDescription.html(partialDescriptionString + "<br/> war dieser Lift an<br/> " + daysNotWorking + " " + days + "<br/><span class=\"bolder\">defekt</span></p>");
  };

  $('#lifts-list li').each(function(index, value) {
    var liftId = $(this).data('lift_id'),
          $that = $(this);

    BROKENLIFT.api.fetchResource('lifts/' + liftId + '/statistics.json/?days=' + maxDaysToRenderIntoChart, function(data){
      var lift = data.lift;

      renderDownTimePercentage(liftId, lift.downTime);
      renderDownTimeAbsolute(liftId, lift.downTimeEvents);
      renderDownTimeHistory(liftId, lift.dailyStatusHistory);
    });
  });

});
