class Holiday < ActiveRecord::Base
  validates :name, :date, presence: true

  class << self
    def holidays_in_current_sprint
      current_sprint = Sprint.current_sprint
      where(date: (current_sprint.start_date..current_sprint.end_date) ).count
    end
  end
end
