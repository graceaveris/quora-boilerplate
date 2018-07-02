class User < ActiveRecord::Base
	has_secure_password

	validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :username, presence: true, uniqueness: true

	has_many :questions
end