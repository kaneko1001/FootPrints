class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.string :image
      t.string :location
      t.decimal :map_latitude, precision: 10, scale: 6
      t.decimal :map_longitude, precision: 10, scale: 6
      t.date :departure_date
      t.date :return_date

      t.timestamps
    end
  end
end
