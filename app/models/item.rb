class Item < ApplicationRecord
  LOWEST_PRIORITY = (2 ** 31) - 1

  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :purchasers, through: :purchases, source: :user

  validates :priority, numericality: { only_integer: true, in: 0..LOWEST_PRIORITY }
  validates :name, presence: true
  validate_identifier :name
  validates :plural, inclusion: { in: ['singular', 'plural'] }, presence: true

  def priority
    val = super
    if val and val < LOWEST_PRIORITY
      val
    else
      nil
    end
  end

  def priority=(val)
    # This runs before validation on create and update, so we need to convert and validate independently
    if val.nil? or val == ''
      return super(LOWEST_PRIORITY)
    end
    if val.class == String
      val = val.to_i
    end
    if val >= LOWEST_PRIORITY
      return super(LOWEST_PRIORITY)
    end
    super(val)
  end

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

  # Items are sorted ascending by this value, so high priority items have smaller sort values
  def purchase_sort_value(user)
    if purchasers.empty?
      0
    else
      if plural?
        1
      else
        2
      end
    end
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
