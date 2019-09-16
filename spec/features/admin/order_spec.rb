require 'rails_helper'

describe 'Admin can see all orders' do
  before :each do
    @dog_shop = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
    @pull_toy = @dog_shop.items.create!(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
    @dog_bone = @dog_shop.items.create!(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)

    @admin = User.create!(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    @admin_address = @admin.addresses.create!(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80_021)

    @user_1 =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    @address_1 = @user_1.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    @user_2 =  User.create!(name: 'alec', email: '4@gmail.com', password: 'password')
    @address_2 = @user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    @order_1 = @user_1.orders.create!(address_id: @address_1.id, status: 0)
    @order_2 = @user_2.orders.create!(address_id: @address_2.id, status: 1)

    @item_order_1 = ItemOrder.create!(order: @order_1, item: @pull_toy, price: @pull_toy.price, quantity: 2)
    @item_order_2 = ItemOrder.create!(order: @order_2, item: @pull_toy, price: @pull_toy.price, quantity: 2)

    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button 'Log In'
  end

  it 'they can see order details' do
    visit '/admin'
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_2.id)

    within "#order-id-#{@order_1.id}" do
      expect(page).to have_content("Placed by: #{@order_1.user.name}")
      expect(page).to have_content("Date created: #{@order_1.created_at.strftime('%d %b %y')}")
      expect(page).to have_content("Order Status: #{@order_1.status}")
      click_link("Placed by: #{@order_1.user.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}")
    expect(page).to have_content(@user_1.name)
    expect(page).to_not have_link('Edit Profile')
  end

  it "they can see button to ship packaged orders, and when ship button is clicked,
    the status of the order changes to shipped" do
    visit '/admin'
    within "#order-id-#{@order_2.id}" do
      expect(page).to have_content('Order Status: packaged')
      expect(page).to have_button("Ship Order #{@order_2.id}")
      click_button("Ship Order #{@order_2.id}")
    end
    expect(current_path).to eq('/admin')
    within "#order-id-#{@order_2.id}" do
      expect(page).to have_content('Order Status: shipped')
    end
  end
end
