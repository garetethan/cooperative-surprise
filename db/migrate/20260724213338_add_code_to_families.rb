class AddCodeToFamilies < ActiveRecord::Migration[7.2]
  def change
    add_column :families, :code, :string
    add_index :families, :code, unique: true
  end
end
