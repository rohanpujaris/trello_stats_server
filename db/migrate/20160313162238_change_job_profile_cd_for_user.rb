class ChangeJobProfileCdForUser < ActiveRecord::Migration
  def change
    change_column :members, :job_profile_cd, :integer, default: 0
  end
end
