class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :family, foreign_key: :family_code, primary_key: :code
  has_one :administered_family, class_name: 'Family', foreign_key: 'admin_id'

  # Families and initial users (who create a new family on sign-up) have a chicken and egg relationship.
  # A family can't have an admin that does not exist yet, and a user can't belong to a family that doesn't exist yet.
  # The compromise is that families are permitted to have no specified admin during the creation process.
  # The order and timing of set_or_create_family, set_family_admin, and destroy_administered_family are delicately designed to accomodate these restrictions.
  before_validation :set_or_create_family, on: :create
  after_create :set_family_admin, if: -> { self.family_status == 'new' }
  validates :family_status, on: :create, presence: true
  validates :name, presence: true

  before_destroy :unadmin, if: -> { self.administered_family }
  after_destroy :destroy_family, if: -> { self.family.users.size == 1 }

  # family_status getters / setters are required because of the radio buttons in the user registration view, even though the field is ignored by the server upon submission
  attr_accessor :family_status, :family_name

  private

  def set_or_create_family
    if family_status == 'new'
      new_family = Family.new(name: family_name)
      # Validate the new family so that it has a family_code
      new_family.valid?
      # Indirectly set the user's family_code
      self.family = new_family
    end
    # Setting an existing family has not yet been implemented
  end

  # Only runs if the user is creating a new family
  def set_family_admin
    family.update!(admin: self)
  end

  # Only runs if the user is an admin
  def unadmin
    administered_family.update!(admin: nil)
  end

  # Only runs if the user being deleted is the only one in their family
  def destroy_family
    self.family.destroy
  end
end
