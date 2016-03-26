class Leave < ActiveRecord::Base
  belongs_to :member
  belongs_to :last_updated_by, class_name: 'Member'

  validates :member, presence: true
  validates :date, presence: true

  default_scope -> { order(date: :desc) }
end
