class CreateCardSprints < ActiveRecord::Migration
  def change
    create_table :card_sprints do |t|
      t.references :card, index: true, foreign_key: true
      t.references :sprint, index: true, foreign_key: true
      t.string :individual_sprint_points

      t.timestamps null: false
    end
  end
end
