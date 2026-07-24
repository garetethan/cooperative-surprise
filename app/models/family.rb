require 'securerandom'

class Family < ApplicationRecord

  # Ten lowercase letters gives 1.4 * 10^14 different possible codes
  @@code_charset = ('a'..'z').to_a
  @@code_length = 10

  before_validation :generate_code, on: :create
  has_many :users

  private

  def generate_code
    letters = Array.new(@@code_length) { @@code_charset[SecureRandom.random_number(@@code_charset.size)] }
    self.code = letters.join()
  end
end
