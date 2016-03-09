class PullAllDataFromTrello < ActiveJob::Base
  def perform(user_id)
    RvTrello.pull_data_from_trello
    User.find(user_id).create_sync_record(:all_data)
  end
end
