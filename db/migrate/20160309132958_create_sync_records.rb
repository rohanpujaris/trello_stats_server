class CreateSyncRecords < ActiveRecord::Migration
  def change
    create_table :sync_records do |t|
      t.time :synced_time
      t.references :user, index: true, foreign_key: true
      t.integer :category_cd, default: 0

      t.timestamps null: false
    end
  end
end
