class CreatePost < ActiveRecord::Migration[8.1]
  def change
    create_table :post do |t|
      t.string :title
      t.text :content
      t.string :category
      t.datetime :published_at

      t.timestamps
    end
  end
end
