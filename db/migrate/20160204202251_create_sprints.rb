class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :name
      t.string :trello_id

      t.timestamps null: false
    end
  end
end
