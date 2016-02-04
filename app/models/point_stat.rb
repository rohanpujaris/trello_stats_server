class PointStat < ActiveRecord::Base
  belongs_to :member_id
  belongs_to :sprint
end
