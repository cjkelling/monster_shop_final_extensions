class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :address_nickname, presence: true

  validates_length_of :zip, is: 5
  validates_numericality_of :zip

  def shipped_order
    orders.select(status: 'shipped')
  end
end
