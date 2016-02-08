class CreateMemberLeaves < ActiveRecord::Migration
  def change
    create_table :member_leaves do |t|
      t.references :member, index: true, foreign_key: true
      t.date :date
    end
  end
end
