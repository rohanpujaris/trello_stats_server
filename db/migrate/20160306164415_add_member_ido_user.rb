class AddMemberIdoUser < ActiveRecord::Migration
  def change
    add_column :users, :member_id, :integer
    add_index  :users, :member_id
  end
end
