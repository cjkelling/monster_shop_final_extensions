require 'rails_helper'

describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      @address = @user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button "Log In"

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"

      click_on "Checkout"
    end

    it 'I can create a new order' do
      choose 'order[address_id]'

      click_button "Create Order"

      new_order = Order.last
      expect(current_path).to eq("/user/orders")

      visit "/user/orders/#{new_order.id}"

      within '.shipping-address' do
        expect(page).to have_content(@address.address_nickname)
      end

      within "#item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end

      within "#datecreated" do
        expect(page).to have_content(new_order.created_at)
      end
    end

    # it 'i cant create order if info not filled out' do
    #   choose 'order[address_id]'
    #
    #   click_button "Create Order"
    #
    #   expect(page).to have_content("Please complete address form to create an order.")
    #   expect(page).to have_button("Create Order")
    # end
  end
end
