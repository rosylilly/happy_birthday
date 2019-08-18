class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.string :title, null: false, limit: 255

      t.timestamps null: false

      t.index :title, unique: true
    end
  end
end
