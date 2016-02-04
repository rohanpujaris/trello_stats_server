class CreatePointStats < ActiveRecord::Migration
  def change
    create_table :point_stats do |t|
      t.references :member, index: true, foreign_key: true
      t.references :sprint, index: true, foreign_key: true
      t.string :doing
      t.string :in_qa
      t.string :qa_passed

      t.timestamps null: false
    end
  end
end
