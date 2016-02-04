class CreateCardMembers < ActiveRecord::Migration
  def change
    create_table :card_members do |t|
      t.references :card, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.integer :individuals_point

      t.timestamps null: false
    end
  end
end
