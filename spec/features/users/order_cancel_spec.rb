require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @regular_user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    @address = @regular_user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_button "Log In"
  end

  it "I can cancel my orders if status is pending" do
    order_1 = @regular_user.orders.create(address_id: @address.id, status: 0)
    item_order_1 = ItemOrder.create(order_id: order_1.id, item_id: @tire.id, quantity: 2, price: 100)
    visit "/user/orders/#{order_1.id}"
    click_link "Cancel Order"
    expect(item_order_1.status).to eq("unfulfilled")
    expect(current_path).to eq("/user/orders")
    expect(page).to have_content("Order #{order_1.id} has been cancelled")
    visit "/user/orders/#{order_1.id}"
    expect(page).to have_content("Order status: cancelled")

  end
  it "I cannot cancel my orders if status is shipped" do
    @order_1 = @regular_user.orders.create!(address_id: @address.id, status: 0)
    @order_2 = @regular_user.orders.create!(address_id: @address.id, status: 2)
    @item_order_1 = ItemOrder.create!(order: @order_1, item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = ItemOrder.create!(order: @order_2, item: @tire, price: @tire.price, quantity: 2)

    visit "/user/orders/#{@order_2.id}"
    expect(page).to_not have_link("Cancel Order")
    visit "/user/orders/#{@order_1.id}"
    expect(page).to have_link("Cancel Order")
  end
end
