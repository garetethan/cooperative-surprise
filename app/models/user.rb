class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_or_create_family, on: :create
  validates :family_status, presence: true
  validates :family_code, presence: true
  validates :name, presence: true

  belongs_to :family, foreign_key: :family_code, primary_key: :code

  # family_status getters / setters are required because of the radio buttons in the user registration view, even though the field is ignored by the server upon submission
  attr_accessor :family_status

  private

  def set_or_create_family
    if self.family_status == 'new'
      new_family = Family.create!
      puts "DEBUG: #{new_family.code}"
      self.family_code = new_family.code
      puts "DEBUG: #{self.family_code}"
    end
  end
end
