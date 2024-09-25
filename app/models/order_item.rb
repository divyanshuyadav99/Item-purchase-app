class OrderItem < ApplicationRecord
  belongs_to :order
  # belongs_to :souko_zaiko
  validates :quantity, :price, presence: true
end
