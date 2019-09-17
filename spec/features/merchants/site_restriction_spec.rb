require 'rails_helper'

describe 'Merchant Site Navigation' do
  describe "when merchant attempts to navigate to '/admin'" do
    it 'they will encounter a 404 error webpage' do
      user = User.create!(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 1)
      address = user.addresses.create!(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80_021)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
