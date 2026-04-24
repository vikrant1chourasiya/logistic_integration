class CreateLinetimes < ActiveRecord::Migration[8.0]
  def change
    create_table :linetimes do |t|
      t.string :sku
      t.integer :quanity
      t.boolean :original
      t.references :orders, null: false, foreign_key: true

      t.timestamps
    end
  end
end
