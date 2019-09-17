require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @user = User.create!(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 1)
      @address = @user.addresses.create!(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80_021)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @order_1 = @user.orders.create(address_id: @user.id, status: 0)
      @order_2 = @user.orders.create(address_id: @user.id, status: 0)

      ItemOrder.create(order_id: @order_1.id, item_id: @tire.id, quantity: 2, price: 20)
      ItemOrder.create(order_id: @order_1.id, item_id: @pull_toy.id, quantity: 3, price: 2)
      ItemOrder.create(order_id: @order_2.id, item_id: @dog_bone.id, quantity: 1, price: 100)
      ItemOrder.create(order_id: @order_2.id, item_id: @pull_toy.id, quantity: 4, price: 2)
    end

    it 'I can see a merchants statistics' do
      visit "/merchants/#{@brian.id}"

      within ".merchant-stats" do
        expect(page).to have_content("Number of Items: 2")
        expect(page).to have_content("Average Price of Items: $15")
        within ".distinct-cities" do
          expect(page).to have_content("Cities that order these items:")
          expect(page).to have_content("Hershey")
          expect(page).to have_content("Denver")
        end
      end
    end
  end
end
