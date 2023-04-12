class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.string     :item  , null: false
      t.references :fridge, null: false, foreign_key: true
      t.timestamps
    end
  end
end
