class AddPriorityToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :priority, :integer, null: false, default: Item::LOWEST_PRIORITY
  end
end
