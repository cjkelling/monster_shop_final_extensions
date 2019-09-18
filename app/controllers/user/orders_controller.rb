class User::OrdersController < ApplicationController
  def create
    @order = current_user.orders.create(order_params)
    if @order.save
      cart.items.each do |item, quantity|
        @order.item_orders.create(
          item: item,
          quantity: quantity,
          price: item.price,
          merchant_id: item.merchant_id
        )
      end
      session.delete(:cart)
      flash[:success] = 'Order Created!'
      redirect_to '/user/orders'
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def index
    @user = current_user
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.item_orders.each do |item_order|
      item_order[:status] = 'unfulfilled'
      item = Item.find(item_order.item_id)
      item.add(item_order.quantity)
    end
    @order.update(status: 3)
    redirect_to '/user/orders'
    flash[:success] = "Order #{@order.id} has been cancelled"
  end

  def edit
    @user = current_user
    @order = current_user.orders.find(params[:id])
  end

  def update
    @order = current_user.orders.find(params[:id])
    @order.update(order_params)
    redirect_to "/user/orders/#{@order.id}"
    flash[:success] = "Order #{@order.id} has been updated"
  end

  private

  def order_params
    params.require(:order).permit(:address_id)
  end
end
