class PullAllDataFromTrello < ActiveJob::Base
  def perform(user_id)
    return unless SyncRecord.sync_allowed?(:all_data)
    User.find(user_id).sync_record(:all_data) do
      RvTrello.pull_data_from_trello
    end
  end
end
