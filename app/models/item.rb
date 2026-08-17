class Item < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :purchasers, through: :purchases, source: :user

  validates :name, presence: true
  validate_identifier :name
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
    plural == 'plural'
  end

  def plural=(val)
    super(val == 'plural')
  end

  def tag_args(field_name)
    ["item_#{id}[#{field_name}]", self.send(field_name)]
  end

  def tag_kwargs(field_name)
    {id: dom_id_mimic(field_name), form: dom_id_mimic(:form)}
  end

  def dom_id_mimic(prefix = nil)
    if prefix
      "#{prefix}_item_#{id}"
    else
      "item_#{id}"
    end
  end

end
