class MakeFamilyCodeAndNamesNotNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :families, :code, false
    change_column_null :families, :name, false
    change_column_null :users, :family_code, false
    change_column_null :users, :name, false
  end
end
