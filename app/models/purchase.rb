class Purchase < ApplicationRecord
  belongs_to :user, foreign_key: true, optional: true
  belongs_to :item
end
