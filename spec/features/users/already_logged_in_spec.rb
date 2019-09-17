require 'rails_helper'

describe "When a user who is already logged in visits login page" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)

    @regular_user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    @address_1 = @regular_user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    @merchant_user =  User.create!(name: 'alec', email: '4@gmail.com', password: 'password', role: 1, merchant_id: @bike_shop.id)
    @address_2 = @merchant_user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    @admin_user =  User.create!(name: 'alec', email: '3@gmail.com', password: 'password', role: 3)
    @address_3 = @admin_user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
  end

  it "regular users are redirected to profile" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq("/users/#{@regular_user.id}")
    expect(page).to have_content("Already logged in")
  end

  it "merchant users are redirected to dashboard" do
    visit '/login'

    fill_in :email, with: @merchant_user.email
    fill_in :password, with: @merchant_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Already logged in")
  end

  it "admin users are redirected to dashboard" do
    visit '/login'

    fill_in :email, with: @admin_user.email
    fill_in :password, with: @admin_user.password

    click_button "Log In"
    visit '/login'
    expect(current_path).to eq('/admin')
    expect(page).to have_content("Already logged in")
  end
end
