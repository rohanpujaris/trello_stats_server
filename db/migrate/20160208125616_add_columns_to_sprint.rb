class AddColumnsToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :start_date, :date
    add_column :sprints, :end_date, :date
  end
end
