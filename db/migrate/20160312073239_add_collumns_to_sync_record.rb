class AddCollumnsToSyncRecord < ActiveRecord::Migration
  def change
    remove_column :sync_records, :synced_time
    rename_column :sync_records, :category_cd, :sync_type_cd
    add_column :sync_records, :sync_start_time, :datetime
    add_column :sync_records, :sync_end_time, :datetime
  end
end
