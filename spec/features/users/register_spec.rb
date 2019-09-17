require 'rails_helper'

describe 'User Registration' do
  describe 'when user clicks on register' do
    it 'they can fill out a form to register new user' do
      visit '/items'

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

      name = 'alec'
      address = '234 Main'
      city = 'Denver'
      state = 'CO'
      zip = 80204
      email = 'alec@gmail.com'
      password = 'password'
      password_confirmation = 'password'

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in "Zip", with: zip
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password_confirmation

      click_button 'Create User'

      user = User.last

      expect(current_path).to eq("/users/#{user.id}")
      expect(page).to have_content("Welcome, #{user.name}")
    end

    it 'they have to fill out entire form' do
      visit '/register'

      click_button 'Create User'

      expect(page).to have_content("Name can't be blank")
      # expect(page).to have_content("Address can't be blank")
      # expect(page).to have_content("City can't be blank")
      # expect(page).to have_content("State can't be blank")
      # expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Password digest can't be blank")

      expect(current_path).to eq('/users')
    end

    it 'they have to use unique email address' do
      user =  User.create!(name: 'alec', email: 'alec@gmail.com', password: 'password')
      address = user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

      visit '/register'
      name = 'luke'
      address = '134 Main'
      city = 'Denver'
      state = 'CO'
      zip = 80_214
      email = 'alec@gmail.com'
      password = 'password'
      password_confirmation = 'password'

      fill_in 'Name', with: name
      fill_in 'Address', with: address
      fill_in 'City', with: city
      fill_in 'State', with: state
      fill_in "Zip", with: zip
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password_confirmation

      click_button 'Create User'

      expect(current_path).to eq('/users')
      expect(page).to have_content('Email has already been taken')
      expect(user).to eq(User.last)
      expect(find_field('Name').value).to eq(name)
      # expect(find_field('Address').value).to eq(address)
      # expect(find_field(:city).value).to eq(city)
      # expect(find_field(:state).value).to eq(state)
      # expect(find_field(:zip).value).to eq(zip.to_s)
      expect(find_field('Email').value).to eq(email)
      expect(find_field('Password').value).to eq(password)
      expect(find_field('Password confirmation').value).to eq(password_confirmation)
    end
  end
end
