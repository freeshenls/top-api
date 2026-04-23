class CreateCategory < ActiveRecord::Migration[8.1]
  def change
    create_table :category do |t|
      t.string :name
      t.string :icon
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end
end
