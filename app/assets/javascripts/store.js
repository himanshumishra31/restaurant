function Store(data) {
  this.$mealContainerDiv = data.$mealContainerDiv;
}

Store.prototype.fetchMeals = function() {
  var _this = this;
  const POLLING_TIME = 60000;
  setInterval(function(){
    _this.$mealContainerDiv.empty();
    $.ajax({
      url: "/category",
      method: 'GET',
      dataType: 'JSON',
      success: function(response) {
        _this.$mealContainerDiv.html(response.output);
      },
      error: function() {
        console.log('Error occured');
      }
    })
  }, POLLING_TIME);
};

$(function() {
  var data = {
    $mealContainerDiv: $('div[data-name="meal-container"]')
  },
      storeObject = new Store(data);
  storeObject.fetchMeals();
});
