function Store(data) {
  this.mealContainerDiv = data.mealContainerDiv;
}

Store.prototype.clearMealContainer = function() {
  this.mealContainerDiv.empty();
};

Store.prototype.updateStore = function(response) {
  this.mealContainerDiv.html(response.output);
};

Store.prototype.fetchMeals = function() {
  var _this = this;
  setInterval(function(){
    _this.clearMealContainer();
    $.ajax({
      url: "/category",
      method: 'GET',
      dataType: 'JSON',
      success: function(response) {
        _this.updateStore(response);
      },
      error: function() {

      }
    })
  }, 20000);
};

Store.prototype.init = function() {
  this.fetchMeals();
};

$(function() {
  var data = {
    mealContainerDiv: $('div[data-name="meal-container"]')
  },
      storeObject = new Store(data);
  storeObject.init();
});
