class PullAllDataFromTrello < ActiveJob::Base
  def perform
    RvTrello.pull_data_from_trello
  end
end
