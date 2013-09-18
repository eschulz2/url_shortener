class Url < ActiveRecord::Base
  # Remember to create a migration!
  validates :long_url, presence: true
  validates :long_url, uniqueness: true

  def shorten
    temp_ary = []
    8.times { temp_ary << rand(65..90).chr }
    8.times { temp_ary << rand(97..122).chr }
    temp_ary.sample(8).join("")
  end
end