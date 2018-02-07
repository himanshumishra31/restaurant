function MealCategory(data) {
  this.$radioButtonForm = data.$radioButtonForm;
  this.$radionButtons = data.$radionButtons;
}

MealCategory.prototype.bindEvents = function() {
  var _this = this;
  this.$radionButtons.on('change', function() {
    _this.$radioButtonForm.submit();
  });
};

$(document).ready(function() {
  var data = {
    $radioButtonForm: $("form[data-category='options']"),
    $radionButtons: $("input[name='category']")
  }
  new MealCategory(data).bindEvents();
});
