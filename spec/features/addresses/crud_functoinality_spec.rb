require 'rails_helper'

describe "As a registered user" do
  before :each do
    @user = User.create(name: 'Christopher', email: 'christopher@email.com', password: 'p@ssw0rd', role: 0)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    @address_1 = @user.addresses.create(address_nickname: 'Home', address: '123 Oak Ave', city: 'Denver', state: 'CO', zip: 80021)
    @address_2 = @user.addresses.create(address_nickname: 'Work', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80021)
  end

  it 'I can see all my addresses' do
    visit user_path(@user)

    expect(page).to have_content(@address_1.address_nickname)
    expect(page).to have_content(@address_1.address)
    expect(page).to have_content(@address_1.city)
    expect(page).to have_content(@address_1.state)
    expect(page).to have_content(@address_1.zip)

    expect(page).to have_content(@address_2.address_nickname)
    expect(page).to have_content(@address_2.address)
    expect(page).to have_content(@address_2.city)
    expect(page).to have_content(@address_2.state)
    expect(page).to have_content(@address_2.zip)
  end

  it 'I can edit my current address' do
    visit user_path(@user)

    within "#address-#{@address_1.id}" do
      click_link('Edit Address')
    end

    expect(current_path).to eq("/user/addresses/#{@address_1.id}/edit")

    expect(find_field('Address nickname').value).to eq(@address_1.address_nickname)
    expect(find_field('Address').value).to eq(@address_1.address)
    expect(find_field('City').value).to eq(@address_1.city)
    expect(find_field('State').value).to eq(@address_1.state)
    expect(find_field('Zip').value).to eq(@address_1.zip.to_s)

    fill_in 'Address', with: '812 South Ave'
    fill_in 'State', with: 'Maryland'
    click_button 'Update Address'

    @address_1.reload

    expect(@address_1.address).to eq('812 South Ave')
    expect(@address_1.state).to eq('Maryland')
  end

  it 'I can delete my current address' do
    visit user_path(@user)

    within "#address-#{@address_2.id}" do
      click_link('Delete Address')
    end
  end

  it 'I can add new addresses' do
    visit user_path(@user)

    click_link('Add New Address')

    expect(current_path).to eq('/user/addresses/new')

    address_nickname = 'New Work'
    address = '123 Fir St'
    city = 'Boston'
    state = 'Mass'
    zip = '12345'

    fill_in 'Address nickname', with: address_nickname
    fill_in 'Address', with: address
    fill_in 'City', with: city
    fill_in 'State', with: state
    fill_in 'Zip', with: zip
    click_button 'Create Address'

    address_3 = Address.last

    expect(current_path).to eq("/users/#{@user.id}")
    expect(page).to have_content(address_3.address_nickname)
    expect(page).to have_content(address_3.address)
    expect(page).to have_content(address_3.city)
    expect(page).to have_content(address_3.state)
    expect(page).to have_content(address_3.zip)
  end
end
