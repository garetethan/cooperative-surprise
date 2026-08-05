require 'securerandom'

class Family < ApplicationRecord

  # Ten lowercase letters gives 1.4 * 10^14 different possible codes
  @@code_charset = ('a'..'z').to_a
  @@code_length = 10

  has_many :users, foreign_key: :family_code, primary_key: :code
  belongs_to :admin, class_name: 'User', optional: true

  before_validation :generate_code, on: :create
  # allow_nil allows multiple families to have nil admins
  validates :admin, uniqueness: true, allow_nil: true
  validates :name, presence: true

  private

  def generate_code
    letters = Array.new(@@code_length) { @@code_charset[SecureRandom.random_number(@@code_charset.size)] }
    self.code = letters.join()
  end
end
