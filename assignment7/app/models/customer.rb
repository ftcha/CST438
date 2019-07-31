class Customer < ApplicationRecord

  # email, lastName, and firstName can not be empty
  validates_presence_of :email, :lastName, :firstName

  validates_format_of :email,
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    message: "Invalid email"

  validates_uniqueness_of :email, case_sensitive: false,
    message: "email already in used"

end
