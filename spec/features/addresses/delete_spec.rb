require 'rails_helper'

describe "As a registered user" do
  before :each do
    @user = User.create(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @address = @user.addresses.create(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, enabled?: false)
    @tire = @bike_shop.items.create(name: 'Tire', description: 'Great tire!', price: 100, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
    @order = @user.orders.create(address_id: @address.id, status: 2)
    ItemOrder.create(order_id: @order.id, item_id: @tire.id, quantity: 2, price: 20)
  end

  it 'I cannot update an address that is being shipped to' do
    visit user_path(@user)

    within "#address-#{@address.id}" do
      click_link('Edit Address')
    end

    fill_in 'Address', with: '812 South Ave'
    click_button "Update Address"

    expect(page).to have_content('Address is being used to ship an order. It cannot be updated at this time.')
    expect(page).to have_content(@address.address)
  end

  it 'I cannot delete an address that is being shipped to' do
    visit user_path(@user)

    within "#address-#{@address.id}" do
      click_link('Delete Address')
    end

    expect(page).to have_content('Address is being shipped to. It cannot be deleted at this time.')
    expect(page).to have_content(@address.address)
  end
end
