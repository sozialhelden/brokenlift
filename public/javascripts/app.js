/*globals renderTemplate, renderMainContent, renderSideContent, CONFIG */
var routes = [],
    skipNavigation = false;
function fetch(apiUrl, callback, options) {

  $('#loading').show();
  options = options || {};
  var prepare = options.prepare;
  delete options.prepare;
  var url = CONFIG.baseUrl + apiUrl + ".json";
  $.ajax(_.extend({}, {
    url : url,
    dataType: 'jsonp',
    success: function (data) {
      $('#loading').hide();

      if (prepare) {
        data = prepare(data);
      }
      callback(data);
    },
    error: function (err) {
      $('#loading').hide();
      renderMainContent('error', err);
    }
  }, options));
}
function prepareEvent(event) {
  event.dateObj = new Date(event.timestamp);
  event.dateStr = event.dateObj.toString();
}
function setHash(hash, skipNav) {
  skipNavigation = !!skipNav;
  window.location.hash = "#!" + hash;
}
function navigateTo(hash) {
  // update the navigation buttons
  var activeClass = 'white';
  $('nav')
    .find("." + activeClass)
    .removeClass(activeClass)
    .end()
    .find("a[href='#!" + hash + "']")
    .addClass(activeClass)
  ;

  var matched = _.any(routes, function (info) {
    var matches = info[0].exec(hash);
    if (matches) {
      info[1].apply(null, matches.slice(1));
      return true;
    }
    return false;
  });
}

function onHashChange() {
  if (!skipNavigation) {
    navigateTo(window.location.hash.substr(2));
  } else {
    skipNavigation = false;
  }
}

$(document).ready(function () {

  /* ROUTE HANDLERS --------- */

  function lift(id) {
    fetch("/lifts/" + id, function (data) {
      if (data.lift.station.location && data.lift.station.location.latitude != null) {
        renderSideContent("map", data.lift.station.location);
      }
      renderMainContent("detailpage", data.lift);
      //renderMainContent("lift", data);
      showPieChart('uptimePercentagePieChart',data.lift.uptimePercentage);
      showEventBrokenDurationChart('eventBrokenDurationChart',data.lift.events);
    }, {
      prepare: function (data) {
        var lift = data.lift;
        var events = lift.events;
        var now = new Date();
        events.reverse();
        _.each(events, prepareEvent);
        _.each(events, function (event, i){
          //prepareEvent(event);
          if (events[i+1]) {
            event.duration = (events[i+1].dateObj - event.dateObj);
          } else {
            event.duration = now.getTime()-event.dateObj;
          }
        });
        events.reverse();
        lift.uptimePercentage = calcUptimePercentage(lift.events,now);

        return data;
      }
    });
  }

  function list() {
    fetch("/lifts/broken", function (data) {
      renderMainContent("listview", data);
    }, {
      prepare: function (data) {
        _.each(data.lifts, function (lift) {
          prepareEvent(lift.last_event);
        });
        return data;
      }
    });
  }

  function home() {
    fetch("/lifts/broken", function (data) {
      renderMainContent("home", data);
      renderSideContent("find-a-station");
      $('#findAStation').attr('disabled', true).val("Loading...");
      fetch("/stations", function (stations) {
        stations = stations.stations;
        $('#findAStation')
          .attr('disabled', false)
          .val('')
          .autocomplete({
            source: _.map(stations, function (station) {
              return {
                label : station.name,
                value: station.id
              };
            }),
            select: function( event, ui ) {
              var stationId = ui.item.value;
              $( "#findAStation" ).val('');

              setHash("/stations/" + stationId);
              return false;
            },
            focus: function(event, ui) {
              $( "#findAStation" ).val( ui.item.label );
              return false;
            }
          })
        ;
      });
    }, {
      prepare: function (data) {
        _.each(data.lifts, function (lift) {
          prepareEvent(lift.last_event);
        });
        return data;
      }
    });
  }

  function operators(id) {
    fetch("/operators/" + id, function (data) {
    //fetch("/operators/" + id + "/lifts", function (data) {
      renderMainContent("operators", data);
    });
  }

  function about() {
    renderMainContent("about");
  }
  function report() {
    renderMainContent("report");
  }
  function follow(ids) {
    fetch("/stations/status", function (data) {
      var stations = data.stations;
      function appendStation(id) {
        id = parseInt(id, 10);
        var station = _.find(stations, function (station) {
          return station.id === id;
        });
        if (station) {
          $('#selectedStations').append(renderTemplate('station-overview', station));
        }
      }
      var selectedStations = [];
      if (ids) {
        ids = ids.split(',');
        selectedStations = ids.map(function (id) {
          return _.find(stations, function (station) {
            return station.id === parseInt(id, 10);
          });
        });
      } else {
        ids = [];
      }
      renderMainContent("follow", {
        selectedStations: selectedStations
      });
      $('#addStation').autocomplete({
        source: _.map(stations, function (station) {
          return {
            label : station.name,
            value: station.id
          };
        }),
        select: function( event, ui ) {
          var stationId = ui.item.value;
          $( "#addStation" ).val('');
          ids.push(stationId);
          setHash("/follow/" + ids.join(","), true);
          appendStation(stationId);
          return false;
        },
        focus: function(event, ui) {
          $("#addStation").val(ui.item.label);
          return false;
        }
      });
    });
  }
  function lifts() {
    renderMainContent("todo");
  }
  function station(id) {
    fetch("/stations/" + id+'/lifts', function (data) {
      data.station = data.lifts[0].station;
      if (data.station.location && data.station.location.latitude != null) {
        renderSideContent("map", data.station.location);
      }
      _.each(data.lifts, function(lift) {
        lift.latestEvent = lift.events[0];
      });
      renderMainContent("station", data);
    });
  }
  /* HELPER FUNCTIONS ---------------- */

  /**
   * Get the percentage of time that a lift has been open (since the first recorded event)
   * @param  {Array} events Array of event objects
   * @return {Number} Percentage, in the range 0-100
   */
  function calcUptimePercentage(events,now) {
    var uptime = 0;
    _.each(events, function (event, i) {
      if (event.is_working) {
        uptime += event.duration;
      }
    });
    var wholeTime = now-events[events.length-1].dateObj;
    return uptime/wholeTime*100;
  }

  function showPieChart(containerId,uptimePercentage){
    var data = [{label:'Up',data:uptimePercentage,color:'#4f0'},{label:'Down',data:100-uptimePercentage,color: '#f30'}];
      $.plot($("#"+containerId), data,
    {
          series: {
              pie: {
                  show: true
              }
          },
          legend: {
              show: false
          }
    });
  }

  function showEventBrokenDurationChart(containerId,events) {
      var data = [];
      var counter=0;
      events.reverse();
      _.each(events,function(event){
        if (!event.is_working) {
          data.push([counter++,event.duration/1000/60]);
        }
      });

      $.plot($("#"+containerId), [
          {
              data: data,
              bars: { show: true },
              color: '#f00'
          }
      ], {
        yaxes:[ {
              tickFormatter: function formatter(val, axis){
                  return val + " min";
              }
             }],
        xaxes:[ {
              tickFormatter: function formatter(val, axis){
                  return "";
              }
             }]
      });

      events.reverse();

      function paintChart(){
          var chart = $("#"+containerId);
          $.plot(chart, [{
              data: data,
              lines: {
                  show: true
              },
              points: {
                  show: true
              },
              color: 'rgb(0,255,0)',
              label: 'Time per day calculation (in seconds)'
          }],
          {
              xaxis: {
                  ticks: 0
              },
              yaxis: {
                  min: 0,
                  tickFormatter: function formatter(val, axis){
                      return val + " s";
                  }
              },
              legend: {
                  position: 'se'
              }
          });
          //chart.bind("plothover", onPlotHover);
      }

        //paintChart();

  }

  /* ROUTING ------------- */

  routes.push([
    /^\/?$/, home
  ], [
    /^\/lift\/(\d+)$/, lift
  ], [
    /^\/lifts$/, list
  ], [
    /^\/about/, about
  ], [
    /^\/report/, report
  ], [
    /^\/operators\/(\d+)$/, operators
  ], [
    /^\/follow(?:\/(\d+(?:,\d+)*))?/, follow
  ], [
    /^\/stations\/(\d+)/, station
  ], [
    /.?/, function () {
      renderMainContent('error', {status: 404});
    }
  ]);
  $('#loading').hide();
  $(window).bind('hashchange', onHashChange);
  onHashChange();
});
