class Merchant::ItemordersController < Merchant::BaseController
  def fulfill
    @item_order = ItemOrder.find(params[:id])
    @item_order.fulfill_and_save_item_order
    item = Item.find(@item_order.item_id)
    item.subtract(@item_order.quantity)
    order = Order.find(@item_order.order_id)
    order.packaged if order.all_item_orders_fulfilled?
    redirect_to "/merchant/orders/#{@item_order.order_id}"
    flash[:success] = "#{item.name} is now fulfilled"
  end
end
