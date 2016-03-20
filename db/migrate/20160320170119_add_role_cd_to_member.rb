class AddRoleCdToMember < ActiveRecord::Migration
  def change
    add_column :members, :role_cd, :integer, default: 0
  end
end
