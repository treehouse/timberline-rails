class Timberline
  class Rails
    class ActiveJobWorker < ::Timberline::Worker
      def process_item(item)
        ActiveJob::Base.execute item.contents
      rescue StandardError => e
        item.error_reason = e.message
        item.error_backtrace = e.backtrace
        error_item(item)
      end
    end
  end
end
