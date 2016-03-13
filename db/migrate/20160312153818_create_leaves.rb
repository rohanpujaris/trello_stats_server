class CreateLeaves < ActiveRecord::Migration
  def change
    create_table :leaves do |t|
      t.references :member, index: true, foreign_key: true
      t.integer :creator_id
      t.date :date

      t.timestamps null: false
    end

    add_index :leaves, :creator_id
  end
end
