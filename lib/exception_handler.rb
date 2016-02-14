class ExceptionHandler
  DEFAULT_RETRY_COUNT = 3
  MESSAGE_AFTER_RETRY_COMPLETED = 'There is a shitty exception man. Please check and correct your code'
  DECORATOR = "="*80

  class << self
    def retry_if_expection(retry_count = 3, &block)
      begin
        block.call
        return true
      rescue Exception => e
        decorate_exception(e)
        if retry_count.zero?
          decorate_exception { MESSAGE_AFTER_RETRY_COMPLETED }
        else
          retry_if_expection(retry_count - 1, &block)
        end
      end
    end

    def retry_collection_from_offset(options, &block)
      retry_count = options[:retry_count] || DEFAULT_RETRY_COUNT
      index = options[:index] || 0
      collection = options[:collection]
      can_skip_item_if_exception = options[:can_skip_item] || false
      i = 0;
      begin
        for i in (index...collection.length)
          block.call(collection[i])
        end
      rescue  Exception => e
        decorate_exception(e, {"Record generating exception": collection[i]} )
        if retry_count.zero?
          decorate_exception { MESSAGE_AFTER_RETRY_COMPLETED }
          return false if can_skip_item_if_exception
        else
          retry_collection_from_offset({index: i, collection: collection,
            retry_count: retry_count - 1}, &block)
        end
      end
      return true
    end

    def decorate_exception(e=nil, details={})
      Rails.logger.fatal DECORATOR
      if block_given?
        yield
      elsif e
        Rails.logger.fatal e.message
        details.each do |k, v|
          Rails.logger.fatal "#{k} : #{v.respond_to?(:inspect) ? v.inspect : v }"
        end
      end
      Rails.logger.fatal DECORATOR
    end
  end
end