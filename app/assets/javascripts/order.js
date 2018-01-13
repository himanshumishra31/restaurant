function Order(data) {
  this.$ordertablebody = data.$ordertablebody;
}

Order.prototype.fetchOrders = function() {
  var _this = this;
  const POLLING_TIME = 10000;
  setInterval(function(){
    _this.$ordertablebody.empty();
    $.ajax({
      url: "/admin/update_orders",
      method: 'GET',
      datatype: 'JSON',
      success: function(response) {
       _this.$ordertablebody.html(response.output);
      },
      error: function() {
        console.log('Error occured');
      }
    })
  }, POLLING_TIME);
};

$(function() {
  var data = {
    $ordertablebody: $('table[data-name="order-table"] tbody')
  },
    ordersObject = new Order(data);
    ordersObject.fetchOrders();
})
