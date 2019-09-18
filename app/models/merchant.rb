class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_inclusion_of :enabled?, in: [true, false]

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    #merchants have access to item_orders, which have access
    #to orders, which have access to addresses, which is where
    #the city information is stored.
    order_ids = item_orders.joins(:order).pluck(:order_id)
    # .joins(:address).pluck(:city)
    # SELECT city FROM addresses JOIN orders ON order_id JOIN item_orders ON merchant.id
  end

  def get_individual_orders
    item_orders.group(:order_id).select('item_orders.order_id, sum(quantity) as total_quantity, sum(quantity * item_orders.price) as total_subtotal').where(status: 0)
  end

  def toggle
    update(enabled?: !enabled?)
  end

  def activate_items
    items.update(active?: true)
  end

  def deactivate_items
    items.update(active?: false)
  end
end
