class AddColumnsToCard < ActiveRecord::Migration
  def change
    add_column :cards, :sprint_id, :integer
    add_column :cards, :point_expecctation, :integer
    add_index  :cards, :sprint_id
  end
end
