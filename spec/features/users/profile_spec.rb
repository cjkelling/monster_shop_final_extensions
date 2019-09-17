require 'rails_helper'

RSpec.describe "User Profile" do
  describe "As a registered user" do
    before :each do
      @user =  User.create!(name: 'alec', email: '5@gmail.com', password: 'password')
      @address = @user.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @user_2 =  User.create!(name: 'alec', email: '4@gmail.com', password: 'password')
      @address_2 = @user_2.addresses.create!(address_nickname: 'Home', address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)
    end

    it 'I visit my profile page and see all my profile data except my password. I see a link to edit my profile data.' do
      visit "/users/#{@user.id}"

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@address.address_nickname)
      expect(page).to have_content(@address.address)
      expect(page).to have_content(@address.city)
      expect(page).to have_content(@address.state)
      expect(page).to have_content(@address.zip)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit Profile')
    end

    it 'I click the Edit Profile link. I see a prepopulate form with my current info. I submit the form and am returned to my profile page with my new info.' do
      visit "/users/#{@user.id}"
      click_link 'Edit Profile'
      expect(current_path).to eq("/users/#{@user.id}/edit")
      expect(find_field('Name').value).to eq(@user.name)
      expect(find_field('Email').value).to eq(@user.email)

      name = 'Christopher'
      email = 'christopher@email.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      click_button 'Update User'

      expect(current_path).to eq("/users/#{@user.id}")

      expect(page).to have_content('Your profile has been updated')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it 'I see a link to edit my password. I fill out the form and am returned to my profile. I see a flash message confirming the update.' do
      visit "/users/#{@user.id}"
      click_link 'Edit Password'

      expect(current_path).to eq("/users/#{@user.id}/password_edit")

      password = 'password'
      password_confirmation = 'password'

      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password_confirmation

      click_button 'Update User'

      expect(current_path).to eq("/users/#{@user.id}")
      expect(page).to have_content('Your password has been updated')
    end

    it 'I must use a unique email address when updating my profile' do
      visit "/users/#{@user.id}/edit"

      email = '4@gmail.com'

      fill_in "Email", with: email
      click_button 'Update User'

      expect(current_path).to eq("/users/#{@user.id}/edit")
      expect(page).to have_content("Email has already been taken")
    end
  end
end
