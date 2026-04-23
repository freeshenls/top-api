class CreateSite < ActiveRecord::Migration[8.1]
  def change
    create_table :site do |t|
      t.string :name
      t.string :url
      t.string :description
      t.string :icon_url
      t.references :category, null: false, foreign_key: true
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end
end
