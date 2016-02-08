class AddCurrentSprintToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :current_sprint, :boolean, default: false
  end
end
