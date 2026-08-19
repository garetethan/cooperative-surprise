class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  belongs_to :family, foreign_key: :family_code, primary_key: :code
  # If a family's admin is destroyed, the family continues to exist with a null admin_id value
  has_one :administered_family, class_name: 'Family', foreign_key: 'admin_id', dependent: :nullify
  has_many :items, dependent: :destroy
  has_many :purchases, dependent: :nullify
  has_many :purchased_items, through: :purchases, source: :item

  # Families and initial users (who create a new family on sign-up) have a chicken and egg relationship.
  # A family can't have an admin that does not exist yet, and a user can't belong to a family that doesn't exist yet.
  # The compromise is that families are permitted to have no specified admin during the creation process.
  # The order and timing of set_or_create_family, set_family_admin, and destroy_family are delicately designed to accomodate these restrictions.
  before_validation :set_or_create_family, on: :create

  validates :family_status, on: :create, presence: true
  validates :family_name, on: :create, if: :new_family?, presence: true
  validate_identifier :family_name, on: :create
  validates :family_code, on: :create, unless: :new_family?, presence: true, length: { is: 10 }
  validates :name, presence: true
  validate_identifier :name

  after_create :set_family_admin, if: :new_family?

  # By the time after_destroy runs, the user being destroyed no longer appears in the family's users
  after_destroy :destroy_family, if: -> { self.family.users.size == 0 }

  # family_status getters / setters are required because of the radio buttons in the user registration view, even though the field is ignored by the server upon submission
  attr_accessor :family_status, :family_name

  private

  def new_family?
    family_status == 'new'
  end

  def set_or_create_family
    if new_family?
      new_family = Family.new(name: family_name)
      # Validate the new family so that it has a family_code
      new_family.valid?
      # Indirectly set the user's family_code
      self.family = new_family
    else
      self.family = Family.find_by code: family_code
    end
  end

  # Only runs if the user is creating a new family
  def set_family_admin
    family.update!(admin: self)
  end

  # Only runs if the user being deleted is the only one in their family
  def destroy_family
    self.family.destroy
  end
end
