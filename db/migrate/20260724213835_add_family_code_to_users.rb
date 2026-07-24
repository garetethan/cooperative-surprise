class AddFamilyCodeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :family_code, :string
    add_index :users, :family_code
    add_foreign_key :users, :families, column: :family_code, primary_key: :code
  end
end
