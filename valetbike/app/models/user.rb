class User < ApplicationRecord
  has_secure_password

  validates :identifier, presence: true, numericality: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { maximum: 20, too_long: "%{count} characters is the maximum allowed" }
  validates :first, presence: { message: "name can't be blank" }
  validates :last, presence: { message: "name can't be blank" }
  validates :email, presence: true, uniqueness: true, format: { with: /\A(.+)@(.+)\z/, message: "invalid"  }
  validates :password, length: { minimum: 8 }
  attribute :hours, :float
  attribute :balance, :float

  has_many :rentals
end

# do we actually validate length of password?
