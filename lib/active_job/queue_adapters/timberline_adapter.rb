module ActiveJob
  module QueueAdapters
    # To use Timberline set the queue_adapter config to +:timberline+.
    #
    #   Rails.application.config.active_job.queue_adapter = :timberline
    class TimberlineAdapter
      def enqueue(job)
        Timberline.push job.queue_name, job.serialize
      end

      def enqueue_at(job, timestamp)
        raise NotImplementedError
      end
    end
  end
end
