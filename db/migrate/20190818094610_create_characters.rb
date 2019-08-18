class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.belongs_to :work, null: false, foreign_key: true
      t.string :name, null: false, limit: 255
      t.string :name_kana, null: false, limit: 255
      t.integer :birth_month, null: false, limit: 2, unsigned: true
      t.integer :birth_day, null: false, limit: 2, unsigned: true
      t.integer :gender, null: false, limit: 1, unsigned: true, default: 0

      t.timestamps null: false
    end
  end
end
