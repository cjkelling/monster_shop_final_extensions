require 'rails_helper'

describe "when regular user visits cart" do
  before :each do
    @regular_user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    @address_1 = @regular_user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
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
    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_button "Log In"
  end
  it "they can checkout and and order is created associated with user" do

    visit cart_path
    click_link "Checkout"
    choose 'order[address_id]'
    click_button "Create Order"

    expect(current_path).to eq("/user/orders")
    order = Order.last
    expect(order.status).to eq("pending")
    expect(order.user_id).to eq(@regular_user.id)
    expect(page).to have_content("Order Created!")

    visit '/cart'
    expect(page).to have_content("Cart is currently empty")
    expect(page).to_not have_link("Checkout")

  end
end
