class Lender < ActiveRecord::Base
  has_many :transactions
  has_many :borrowers, through: :transactions

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, presence: true, length: {minimum: 2}
  validates :email, uniqueness: {case_sensitive: false}, format: {with: EMAIL_REGEX}
  validates :money, numericality: {only_integer: true, greater_than: 0}
  has_secure_password
end
