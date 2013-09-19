class User < ActiveRecord::Base
  # Remember to create a migration!
  validates :email, { presence: true, uniqueness: true }
  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :urls

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    (user) && (user.password == password)
  end
end
