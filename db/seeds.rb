Review.destroy_all
Order.destroy_all
Item.destroy_all
Merchant.destroy_all
User.destroy_all

bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

regular_user = User.create!(  name: "alec",
  address: "234 Main",
  city: "Denver",
  state: "CO",
  zip: 80204,
  email: "5@gmail.com",
  password: "password"
)
merchant_admin_user = bike_shop.users.create!(  name: "chris",
  address: "234 Main",
  city: "Denver",
  state: "CO",
  zip: 80204,
  email: "7@gmail.com",
  password: "password",
  role: 2
)
admin_user = User.create!(  name: "chris",
  address: "234 Main",
  city: "Denver",
  state: "CO",
  zip: 80204,
  email: "8@gmail.com",
  password: "password",
  role: 3
)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

merchant_employee_2 = User.create(  name: "alec",
                    address: "234 Main",
                    city: "Denver",
                    state: "CO",
                    zip: 80204,
                    email: "alec1@gmail.com",
                    password: "password",
                    role: 1,
                    merchant_id: bike_shop.id)

merchant_admin = User.create(  name: "Sam",
                    address: "234 Main",
                    city: "Denver",
                    state: "CO",
                    zip: 80204,
                    email: "alec2@gmail.com",
                    password: "password",
                    role: 2,
                    merchant_id: bike_shop.id)
order_1 = regular_user.orders.create(name: "Sam Jackson", address: "223 Main St", city: "Seattle", state: "Washington", zip: 99987, status: 0)
ItemOrder.create(order_id: order_1.id, item_id: tire.id, quantity: 2, price: 100, merchant_id: bike_shop.id)
ItemOrder.create(order_id: order_1.id, item_id: pull_toy.id, quantity: 3, price: 10, merchant_id: dog_shop.id)
