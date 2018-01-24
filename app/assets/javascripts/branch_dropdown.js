function BranchDropdown(data) {
  this.$dropdown_form = data.$dropdown_form;
  this.$dropdown_box = data.$dropdown_box;
}

BranchDropdown.prototype.bindEvents = function() {
  var _this = this;
  this.$dropdown_box.on('change', function() {
    _this.$dropdown_form.submit();
  });
};

$(document).ready(function() {
  var data = {
    $dropdown_form: $("form[data-dropdown='dropdown_form']"),
    $dropdown_box: $("select[data-dropdown='dropdown_box']")
  }
  new BranchDropdown(data).bindEvents();
});
