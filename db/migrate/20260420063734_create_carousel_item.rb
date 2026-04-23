class CreateCarouselItem < ActiveRecord::Migration[8.1]
  def change
    create_table :carousel_item do |t|
      t.string :title
      t.string :description
      t.string :image
      t.string :link
      t.integer :position
      t.boolean :active

      t.timestamps
    end
  end
end
