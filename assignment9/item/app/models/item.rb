class Item < ApplicationRecord

  # email, lastName, and firstName can not be empty
  validates_presence_of :description, :price, :stockQty,
    message: "Missing param(s)."

  validates_numericality_of :price,
    :greater_than => 0,
    message: "Invalid price."

  validates_numericality_of :stockQty,
    :only_integer => true,
    :greater_than => 0,
    message: "Stock must be great than 0."

end