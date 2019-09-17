require 'rails_helper'

describe "When an order has been placed" do
  before :each do
    @user = User.create(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @address = @user.addresses.create(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, enabled?: false)
    @tire = @bike_shop.items.create(name: 'Tire', description: 'Great tire!', price: 100, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
    @order = @user.orders.create(address_id: @address.id, status: 2)
    ItemOrder.create(order_id: @order.id, item_id: @tire.id, quantity: 2, price: 20)
  end

  it 'can be edited if not shipped' do
    visit "/user/orders/#{@order.id}/edit"
    choose "order[address_id]"
    click_button "Update Order"
    expect(page).to have_content("#{@address.address_nickname}")
  end
end
