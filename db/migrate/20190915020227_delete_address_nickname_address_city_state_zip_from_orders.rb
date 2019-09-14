class DeleteAddressNicknameAddressCityStateZipFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :address_nickname
    remove_column :orders, :address
    remove_column :orders, :city
    remove_column :orders, :state
    remove_column :orders, :zip
  end
end
