require 'rails_helper'

describe "When visitor goes to login page" do
  it "regular users can login and are directed to correct page" do
    user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"
    expect(current_path).to eq("/users/#{user.id}")
    expect(page).to have_content("Login in successful!")
  end

  it "merchants can login and are directed to correct page" do
    bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)
    user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password', role: 1, merchant_id: bike_shop.id)
    address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"
    expect(current_path).to eq("/merchant")
    expect(page).to have_content("Login in successful!")
  end

  it "admins can login and are directed to correct page" do
    user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password', role: 3)
    address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"
    expect(current_path).to eq("/admin")
    expect(page).to have_content("Login in successful!")
  end

  it "users can not login with wrong information" do
    user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password', role: 3)
    address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

    visit '/login'

    fill_in :email, with: user.email
    fill_in :password, with: "bad"

    click_button "Log In"
    expect(current_path).to eq("/login")
    expect(page).to have_content("Login information incorrect")
  end
end
