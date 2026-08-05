class AddNameToFamilies < ActiveRecord::Migration[7.2]
  def change
    add_column :families, :name, :string
  end
end
