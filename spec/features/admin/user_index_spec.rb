require 'rails_helper'

describe 'As an Admin User' do
  before :each do
    @admin = User.create!(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 3)
    @admin_address = @admin.addresses.create!(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80_021)
    @user_1 =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
    @address_1 = @user_1.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    @user_2 =  User.create!(name: 'alec', email: '4@gmail.com', password: 'password')
    @address_2 = @user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    visit '/login'

    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password

    click_button 'Log In'
  end

  it 'I can see all the users in the system' do
    visit '/'
    click_link('Users')

    expect(current_path).to eq('/admin/users')
    within "#user-index-#{@user_1.id}" do
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content("Date registered: #{@user_1.created_at}")
      expect(page).to have_content("User type: #{@user_1.role}")
      click_link(@user_1.name.to_s)
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}")

    visit '/admin/users'
    within "#user-index-#{@user_2.id}" do
      expect(page).to have_content(@user_2.name)
      expect(page).to have_content("Date registered: #{@user_2.created_at}")
      expect(page).to have_content("User type: #{@user_2.role}")
      click_link(@user_2.name.to_s)
    end
    expect(current_path).to eq("/admin/users/#{@user_2.id}")
  end

  it 'I can see user profile page' do
    visit("/admin/users/#{@user_2.id}")
    expect(page).to have_content(@user_2.name)
    expect(page).to have_content(@address_2.address_nickname)
    expect(page).to have_content(@address_2.address)
    expect(page).to have_content(@address_2.city)
    expect(page).to have_content(@address_2.state)
    expect(page).to have_content(@address_2.zip)
    expect(page).to have_content(@user_2.email)
    expect(page).to_not have_content(@user_2.password)
    expect(page).to_not have_link('Edit Profile')
  end
end
