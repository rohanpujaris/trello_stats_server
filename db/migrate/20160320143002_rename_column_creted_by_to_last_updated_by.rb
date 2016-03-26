class RenameColumnCretedByToLastUpdatedBy < ActiveRecord::Migration
  def change
    rename_column :leaves, :creator_id, :last_updated_by_id
  end
end
