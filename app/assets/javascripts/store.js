function Store(data) {
  this.mealContainerDiv = data.mealContainerDiv;
}

Store.prototype.clearMealContainer = function() {
  this.mealContainerDiv.empty();
};

Store.prototype.updateStore = function(response) {
  $('html').html(response.output);
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
  }, 30000);
};

Store.prototype.init = function() {
  this.fetchMeals();
};

$(function() {
  var data = {
    mealContainerDiv: $('.container-page')
  },
      storeObject = new Store(data);
  storeObject.init();
});
