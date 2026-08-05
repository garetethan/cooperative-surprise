class AddAdminToFamilies < ActiveRecord::Migration[7.2]
  def change
    add_reference :families, :admin, null: true, foreign_key: { to_table: :users }, index: { unique: true }
  end
end
