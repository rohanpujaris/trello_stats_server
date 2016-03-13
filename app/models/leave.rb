class Leave < ActiveRecord::Base
  belongs_to :member
  belongs_to :creator, class_name: 'Member'

  validates :member, presence: true
end
