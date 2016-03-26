module Api::V1
  class HolidaySerializer < ActiveModel::Serializer
    attributes :id, :name, :date
  end
end
