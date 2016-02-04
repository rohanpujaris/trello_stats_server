class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :name
      t.string :trello_id
      t.integer :points
      t.references :list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
