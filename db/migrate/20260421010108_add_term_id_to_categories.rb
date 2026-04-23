class AddTermIdToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :category, :term_id, :string
    add_index :category, :term_id
  end
end
