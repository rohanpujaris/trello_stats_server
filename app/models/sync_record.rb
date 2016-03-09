class SyncRecord < ActiveRecord::Base
  as_enum :category, all_data: 0

  belongs_to :user

  class << self
    def latest_sync_time(category)
      latest_sync_record(category).try(:synced_time)
    end

    def latest_sync_record(category)
      send(category).order(synced_time: :desc).first
    end
  end

end
