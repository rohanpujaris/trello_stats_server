class AddRoleCdToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_cd, :integer, default: 0
  end
end
