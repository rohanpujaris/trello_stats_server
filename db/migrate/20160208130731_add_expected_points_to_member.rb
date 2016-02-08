class AddExpectedPointsToMember < ActiveRecord::Migration
  def change
    add_column :members, :expected_points, :integer
  end
end
