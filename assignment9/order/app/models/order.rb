class Order < ApplicationRecord
  validates_presence_of :itemId, :description, :customerId, :price, :total, :award
end