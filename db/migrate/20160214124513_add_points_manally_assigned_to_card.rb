class AddPointsManallyAssignedToCard < ActiveRecord::Migration
  def change
    add_column :cards, :points_manuallly_assigned, :boolean, default: false
  end
end
