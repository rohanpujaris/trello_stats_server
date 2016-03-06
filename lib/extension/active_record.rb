module Extension
  module ActiveRecord
    module Base
      def json_api_format_errors
        return if errors.blank?

        errors = errors.to_hash(true).flat_map do |k, v|
          v.map { |msg| { id: k, title: msg } }
        end

        {errors: errors}
      end
    end
  end
end