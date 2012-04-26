var BROKENLIFT = (function(NS){

  var config = {
     baseUrl: "/api/",
     googleMapsAPIKey: "AIzaSyBU3UwKwVYrF4Q9lk6Eqcu3qGpXPZaCClU"      
  };
  
  NS.api = (function() {
  
    var buildUrl = function(apiUrl) {
      var url = config.baseUrl + apiUrl;
      if(url.indexOf('.json') < 0) {
        url + '.json';
      }
      return url;
    };
  
    return {
      fetchResource: function(apiUrl, callback, options) {
        options = options || {};
        var prepare = options.prepare;
        delete options.prepare;
        var url = buildUrl(apiUrl);
        $.ajax($.extend({}, {
          url : url,
          dataType: 'jsonp',
          success: function (data) {
            if (prepare) {
              data = prepare(data);
            }
            callback(data);
          },
          error: function (err) {
            console.log(err);
          }
        }, options));
      }      
    }
    
  })();
  
  return NS;  
  
})(BROKENLIFT || {});