var BROKENLIFT = (function(NS){

  var config = {
     baseUrl: "/api/",
     googleMapsAPIKey: "AIzaSyBU3UwKwVYrF4Q9lk6Eqcu3qGpXPZaCClU"
  };
  
  NS.api = (function() {
  
    return {
      fetchResource: function(apiUrl, callback, options) {
        options = options || {};
        var prepare = options.prepare;
        delete options.prepare;
        var url = config.baseUrl + apiUrl + '.json';
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
            renderMainContent('error', err);
          }
        }, options));
      }      
    }
    
  })();
  
  return NS;  
  
})(BROKENLIFT || {});