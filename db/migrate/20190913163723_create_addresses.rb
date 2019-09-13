class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      t.string :address_nickname
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
