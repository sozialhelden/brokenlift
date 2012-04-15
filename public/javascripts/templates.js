jQuery.extend( jQuery.tmpl.tag, {
  "shortdate": {
    _default: { $1: "$data" },
    open: "if($notnull_1){__.push($1a.format('d/m/y'));}"
  },
  "longdate": {
    _default: { $1: "$data" },
    open: "if($notnull_1){__.push($1a.format('d/m/y H:i'));}"
  },
  "percent": {
    _default: { $1: "$data" },
    open: "if($notnull_1){__.push(($1a * 100).toFixed(1) + '%');}"
  }
});
// wrapper around $.tmpl for dev env only
// adds only a single function call overhead in prod
var renderTemplate = function(name) {
  if (!$.template[name]) {
    $.ajax({
      url: "templates/" + name + ".html",
      async: false,
      cache: false,
      data: null,
      global: false,
      dataType: "text",
      success: function(tmpl){
        $.template(name, tmpl);
      },
      error: function(xhr) {
        throw "Template is missing: " + name;
      },
      beforeSend: $.noop
    });
  }
  return $.tmpl.apply(this, arguments);
};
function renderMainContent(name) {
  $('#main_content').html(renderTemplate.apply(this, arguments));
}
function renderSideContent(name) {
  $('#side_content').html(renderTemplate.apply(this, arguments));
}

// pre-fetch templates used as sub-templates
renderTemplate('station-overview', {});
