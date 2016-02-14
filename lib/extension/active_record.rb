module Extension
  module ActiveRecord
    module Base
      def json_api_format_errors
        return if errors.blank?

        new_hash = errors.to_hash(true).flat_map do |k, v|
          v.map { |msg| { id: k, title: msg } }
        end

        json = {}
        json[:errors] = new_hash
        json
      end
    end
  end
end