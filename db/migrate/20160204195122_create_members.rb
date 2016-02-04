class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :full_name
      t.string :user_name
      t.string :trello_id

      t.timestamps null: false
    end
  end
end
