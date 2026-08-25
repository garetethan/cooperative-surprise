class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :item

  validate :check_for_singular_conflict

  private

  def check_for_singular_conflict
    if not item.plural?
      existing_purchase = Purchase.where.not(id: self.id).where(item: item).take
      if existing_purchase
        errors.add(:singular_conflict)
      end
    end
  end
end
