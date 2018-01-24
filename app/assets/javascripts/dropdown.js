function Dropdown(data) {
  this.$customer_dropdown_form = data.$customer_dropdown_form;
  this.$admin_dropdown_form = data.$admin_dropdown_form;
  this.$admin_dropdown = data.$admin_dropdown;
  this.$customer_dropdown = data.$customer_dropdown;
}

Dropdown.prototype.triggerEvent = function(form) {
  return function() {
    form.submit();
  };
};

Dropdown.prototype.bindEvents = function() {
  this.$admin_dropdown.on('change', this.triggerEvent(this.$admin_dropdown_form));
  this.$customer_dropdown.on('change', this.triggerEvent(this.$customer_dropdown_form));
};

$(document).ready(function() {
  var data = {
    $customer_dropdown_form: $("form[data-dropdown='customer_dropdown_form']"),
    $admin_dropdown_form: $("form[data-dropdown='admin_dropdown_form']"),
    $customer_dropdown: $("select[data-dropdown='customer']"),
    $admin_dropdown: $("select[data-dropdown='admin']")
  },
    dropdownObject = new Dropdown(data);
    dropdownObject.bindEvents();
});
