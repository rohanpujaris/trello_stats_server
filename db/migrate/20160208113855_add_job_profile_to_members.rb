class AddJobProfileToMembers < ActiveRecord::Migration
  def change
    add_column :members, :job_profile_cd, :integer
  end
end
