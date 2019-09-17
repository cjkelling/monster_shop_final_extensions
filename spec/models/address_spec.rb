require 'rails_helper'

describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }
  end

  describe 'relationships' do
    it { should have_many :orders }
  end

  it 'can show addresses that have been shipped to' do
    user = User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    order_1 = user.orders.create!(address_id: address.id, status: 0)
    order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

    expect(address.shipped_order).to include(address)
  end
end
