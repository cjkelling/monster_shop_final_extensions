require 'rails_helper'

describe ItemOrder, type: :model do
  describe 'validations' do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :order }
    it { should have_one :merchant }
  end

  describe 'instance methods' do
    it 'subtotal' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = user.orders.create!(address_id: address.id, status: 0)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    it 'fulfill_and_save_item_order' do
      user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = user.orders.create!(address_id: address.id, status: 0)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: 0)

      expect(item_order_1.status).to eq('unfulfilled')
      item_order_1.fulfill_and_save_item_order
      expect(item_order_1.status).to eq('fulfilled')
    end
  end
end
