class CreateActivity < ActiveRecord::Migration[8.1]
  def change
    create_table :activity do |t|
      t.string :title
      t.text :description
      t.string :status
      t.date :event_date
      t.string :location

      t.timestamps
    end
  end
end
