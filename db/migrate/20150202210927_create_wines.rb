class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :producer
      t.integer :vintage
      t.json :varietals, default: '[]'
      t.string :designation
      t.timestamps null: false
    end
  end
end
