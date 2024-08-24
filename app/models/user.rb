class User < ApplicationRecord
  has_secure_password

  validates :username, uniqueness: true, length: { in: 4..32 }, format: { with: /\A[\w]+\z/,
                                                                          message: "only allows letters, numbers, and underscore" }

  normalizes :username, with: ->(username) { username.downcase.strip }
end