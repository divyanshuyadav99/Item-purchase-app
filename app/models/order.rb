class Order < ApplicationRecord
    has_many :order_items
    validates :total_amount, presence: true
end
