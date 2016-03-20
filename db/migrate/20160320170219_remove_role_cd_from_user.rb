class RemoveRoleCdFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :role_cd
  end
end
