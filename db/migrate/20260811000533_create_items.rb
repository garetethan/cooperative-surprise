class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :price
      t.text :description
      t.text :link
      t.boolean :plural
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
