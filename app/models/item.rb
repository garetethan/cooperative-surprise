class Item < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :purchasers, through: :purchases, source: :user

  validates :name, presence: true
  validates :plural, inclusion: { in: ['singular', 'plural'] }

  # Allow views to autofill the right radio button
  def plural
    if super
      'plural'
    else
      'singular'
    end
  end

  def plural?
    self.plural
  end

  def plural=(val)
    super(val == 'plural')
  end

end
