class MemberSprintLeave < ActiveRecord::Base
  belongs_to :member
  belongs_to :sprint
end
