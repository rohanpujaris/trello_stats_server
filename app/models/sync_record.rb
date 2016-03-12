class SyncRecord < ActiveRecord::Base
  as_enum :sync_type, all_data: 0

  # This is the minimum time diffrence between  two sync request
  # Latest sync request will be droped if it does not satify the time diffrence
  MIN_TIME_BETWEEN_SYNC = {
    all_data: 240  # 4 minutes
  }

  default_scope -> { order(sync_end_time: :asc) }

  belongs_to :user

  class << self
    def last_sync_end_time(sync_type)
      last_sync_record(sync_type).try(:sync_end_time)
    end

    def last_sync_record(sync_type)
      send(sync_type).last
    end

    def sync_in_progress?(sync_type)
      in_progress_sync(sync_type).present?
    end

    def last_in_progress_sync(sync_type)
      in_progress_sync(sync_type).last
    end

    def in_progress_sync(sync_type)
      send(sync_type).where("sync_start_time IS NOT NULL AND sync_end_time IS NULL")
    end

    def sync_allowed?(sync_type)
      return true unless last_sync_end_time = last_sync_end_time(sync_type)
      (Time.now - last_sync_end_time) > MIN_TIME_BETWEEN_SYNC[sync_type]
    end
  end
end
