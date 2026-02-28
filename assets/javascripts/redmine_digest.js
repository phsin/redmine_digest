$(document).ready(function () {
  var select2Jq = (window.jql && window.jql.fn && window.jql.fn.select2) ? window.jql : window.jQuery;

  var toggleProjectList = function () {
    var selectedVal = $("#digest_rule_project_selector").val();
    if ($.inArray(selectedVal, ["selected", "not_selected", "member_not_selected"]) < 0) {
      $("#digest-rule-projects").hide();
    } else {
      $("#digest-rule-projects").show();
    }
  };

  select2Jq("#digest_rule_project_selector").select2({
    width: "40%",
    allowClear: false
  }).on("change", toggleProjectList);

  select2Jq("#digest_rule_raw_project_ids").select2({
    width: "40%",
    multiple: true,
    data: select2Jq("#digest_rule_raw_project_ids").data("options"),
    matcher: function (term, text, option) {
      return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;
    }
  });

  toggleProjectList();
});
