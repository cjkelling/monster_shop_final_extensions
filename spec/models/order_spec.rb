require 'rails_helper'

describe Order, type: :model do
  describe 'validations' do
    it { should validate_presence_of :address_id }
  end

  describe 'relationships' do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
    it { should belong_to :address }
  end

  describe 'instance methods' do
    it 'grandtotal' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      pull_toy = brian.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)

      order_1 = user.orders.create!(address_id: address.id, status: 0)

      order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
      expect(order_1.grandtotal).to eq(230)
      expect(order_1.total_quantity).to eq(5)
    end

    it 'can sort orders' do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      pull_toy = dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
      dog_bone = dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)
      admin = User.create!(name: 'alec', email: '5@gmail.com', password: 'password', role: 3)
      admin_address = admin.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      user = User.create!(name: 'alec', email: '56@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      user_2 = User.create!(name: 'alec', email: '576@gmail.com', password: 'password')
      address_2 = user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      order_1 = user.orders.create!(address_id: address.id, status: 0)
      order_2 = user.orders.create!(address_id: address.id, status: 0)

      expect(Order.all).to eq([order_1, order_2])
      expect(Order.sort_orders).to eq([order_1, order_2])
    end

    it 'packaged' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      order_1 = user.orders.create!(address_id: address.id, status: 0)
      expect(order_1.status).to eq('pending')
      order_1.packaged
      expect(order_1.status).to eq('packaged')
    end

    it 'shipped' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      order_2 = user.orders.create!(address_id: address.id, status: 0)
      expect(order_2.status).to eq('pending')
      order_2.shipped
      expect(order_2.status).to eq('shipped')
    end

    it 'checks if all item orders of an item are fulfilled' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      @order_1 = user.orders.create!(address_id: address.id, status: 0)
      @order_1.packaged
      expect(@order_1.all_item_orders_fulfilled?).to eq(true)
    end

    it 'shows all itemorders associated with a merchant' do
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
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      @order_1 = user.orders.create!(address_id: address.id, status: 0)
      @itemorder_2 = ItemOrder.create(order_id: @order_1.id, item_id: @paper.id, quantity: 1, price: 20, merchant_id: @bike_shop.id)
      @itemorder_3 = ItemOrder.create(order_id: @order_1.id, item_id: @pink_helmet.id, quantity: 3, price: 51, merchant_id: @meg.id)
      expect(@order_1.show_order(@meg.id)).to eq([@itemorder_3])
    end
  end
end
