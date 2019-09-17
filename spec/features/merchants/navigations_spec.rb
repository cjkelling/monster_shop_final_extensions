require 'rails_helper'

describe 'As a mechant employee or merchant admin' do
  it 'I see same links as regular usee and link to dashboard' do
    user = User.create!(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 2)
    address = user.addresses.create!(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80_021)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/items'

    within '.topnav' do
      expect(page).to have_link('Merchant Dashboard')
    end
  end
end
