require 'rails_helper'

RSpec.describe 'Items Index Page' do
  describe 'When I visit the items index page' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11_234)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      @paper = @bike_shop.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @bike_shop.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @helmet = @meg.items.create(name: 'Helmet', description: 'Regular helmet', price: 50, image: 'https://www.revzilla.com/product_images/0070/3821/shoei_rf1200_helmet_solid_matte_black_300x300.jpg', inventory: 12)
      @pull_toy = @brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      @pink_helmet = @meg.items.create(name: 'Pink Helmet', description: 'Very pink helmet!', price: 51, image: 'https://images-na.ssl-images-amazon.com/images/I/716FdxJKkjL._SX425_.jpg', inventory: 12)
      @dog_bone = @brian.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)
      @user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      @address = @user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    end

    it 'all items or merchant names are links' do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it 'As a regular user, I can see a list of all active items and I cannot see inactive items ' do
      user_2 = User.create!(name: 'alec', email: '4@gmail.com', password: 'password')
      address_2 = user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      visit '/login'

      fill_in :email, with: user_2.email
      fill_in :password, with: user_2.password

      click_button 'Log In'
      expect(current_path).to eq("/users/#{user_2.id}")

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content('Active')
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content('Active')
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content('Inactive')
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it 'I can see a list of all active items and I cannot see inactive items ' do
      user_2 = User.create!(name: 'alec', email: '3@gmail.com', password: 'password')
      address_2 = user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      visit '/login'

      fill_in :email, with: user_2.email
      fill_in :password, with: user_2.password

      click_button 'Log In'
      expect(current_path).to eq("/users/#{user_2.id}")

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content('Active')
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content('Active')
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content('Inactive')
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it 'I can click on item image and it redirects me to an item show page' do
      user_2 = User.create!(name: 'alec', email: '2@gmail.com', password: 'password')
      address_2 = user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      visit '/login'

      fill_in :email, with: user_2.email
      fill_in :password, with: user_2.password

      click_button 'Log In'
      expect(current_path).to eq("/users/#{user_2.id}")

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_css("img[src*='#{@tire.image}']")
        find("#picture-link-#{@tire.id}").click
      end

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it 'I see quantity purchased statistics about the most and least popular active items ' do
      order_1 = @user.orders.create!(address_id: @address.id, status: 0)
      order_2 = @user.orders.create!(address_id: @address.id, status: 0)
      order_3 = @user.orders.create!(address_id: @address.id, status: 0)
      ItemOrder.create!(order_id: order_1.id, item_id: @paper.id, quantity: 2, price: 20)
      ItemOrder.create!(order_id: order_2.id, item_id: @pencil.id, quantity: 3, price: 2)
      ItemOrder.create!(order_id: order_3.id, item_id: @tire.id, quantity: 1, price: 100)
      ItemOrder.create!(order_id: order_2.id, item_id: @pencil.id, quantity: 4, price: 2)

      visit '/items'
      within '#most-popular-items' do
        expect(page).to have_content('Most Popular Items:')
        expect(page).to have_content("#{@pencil.name}: 7 purchased so far!\n#{@paper.name}: 2 purchased so far!\n#{@tire.name}: 1 purchased so far!")
        expect(page).to_not have_content(@dog_bone.name.to_s)
      end
      within '#least-popular-items' do
        expect(page).to have_content('Least Popular Items:')
        expect(page).to have_content("#{@tire.name}: 1 purchased so far!\n#{@paper.name}: 2 purchased so far!\n#{@pencil.name}: 7 purchased so far!")
        expect(page).to_not have_content(@dog_bone.name.to_s)
      end
    end
  end
end
