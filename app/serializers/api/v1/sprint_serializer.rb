module Api::V1
  class SprintSerializer < ActiveModel::Serializer
    attributes :id, :name, :start_date, :end_date
  end
end
