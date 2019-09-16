Review.destroy_all
Order.destroy_all
Item.destroy_all
Merchant.destroy_all
User.destroy_all

@bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
@tire = @bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)

@dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
@pull_toy = @dog_shop.items.create(name: 'Pull Toy', description: 'Great pull toy!', price: 10, image: 'http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg', inventory: 32)
@dog_bone = @dog_shop.items.create(name: 'Dog Bone', description: "They'll love it!", price: 21, image: 'https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg', active?: false, inventory: 21)

@regular_user = User.create(name: 'User', email: '1@gmail.com', password: '111')
@regular_user_address = @regular_user.addresses.create(address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

@merchant_employee = User.create(name: 'Merch Employy', email: '2@gmail.com', password: '111', role: 1, merchant_id: @bike_shop.id)
@merchant_employee_address = @merchant_employee.addresses.create(address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

@merchant_admin = User.create(name: 'Merch Admin', email: '3@gmail.com', password: '111', role: 2, merchant_id: @bike_shop.id)
@merchant_admin_address = @merchant_admin.addresses.create(address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

@admin = User.create(name: 'Admin', email: '4@gmail.com', password: '111', role: 3)
@admin_address = @admin.addresses.create(address: '234 Main', city: 'Denver', state: 'CO', zip: 80_204)

# @order = @regular_user.orders.create(address_id: @regular_user_address.id)
# order.item_orders.create(item_id: tire.id, quantity: 2, price: 100, merchant_id: bike_shop.id)
# ItemOrder.create(order_id: order.id, item_id: tire.id, quantity: 2, price: 100, merchant_id: bike_shop.id)
# ItemOrder.create(order_id: order.id, item_id: pull_toy.id, quantity: 3, price: 10, merchant_id: dog_shop.id)
