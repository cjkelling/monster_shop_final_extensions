class User < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :addresses
  accepts_nested_attributes_for :addresses
  belongs_to :merchant, optional: true

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password_digest, require: true

  enum role: %w[regular_user merchant_employee merchant_admin admin]

  def no_orders?
    orders.empty?
  end
end
