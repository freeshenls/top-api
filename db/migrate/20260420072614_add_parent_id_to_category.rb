class AddParentIdToCategory < ActiveRecord::Migration[8.1]
  def change
    add_column :category, :parent_id, :integer
  end
end
