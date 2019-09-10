# frozen_string_literal: true

module Sidekiq
  module Middleware
    module Client
      class RequestId
        def initialize(options = nil)
          @options = options || default_options
        end

        def call(_worker, item, _queue, _redis_pool = nil)
          @options[:headers].each do |kv|
            unless kv[:value].nil? || item[kv[:key].to_s]
              item[kv[:key].to_s] = kv[:value].call
            end
          end
          yield
        end

        private

        def default_options
          { headers: [{ key: :request_id, value: -> { ::RequestId.request_id } }] }
        end
      end
    end
  end
end
