class Timberline
  class Rails
    # The ActiveRecordWorker is designed to process items put on
    # the queue by Timberline::Rails::ActiveRecord. It processes items
    # off of the queue, instantiates the specified model, and calls the 
    # specified synchronous method. If the Timberline::Rails::ActiveRecord
    # module is not in use on the model, and the synchronous_method_name method
    # is not defined, the worker will attempt to call method_name instead, so
    # that the worker can still be used for jobs that fit the Timberline::Rails::ActiveRecord
    # format even when the module itself has not been used to dispatch the job.
    #
    # @see Timberline::Rails::ActiveRecord
    #
    class ActiveRecordWorker < ::Timberline::Worker
      
      # Processes items off of a Timberline::Rails::ActiveRecord-compatible
      # queue.
      #
      # @param [Timberline::Envelope] item an Envelope whose contents should be
      #   a hash containing three keys: method_name (the name of the method to call
      #   on the model), model_name (the name of the model on which to call the method),
      #   and model_key (the primary key of the model, for lookup purposes).
      #
      # @see Timberline::Rails::ActiveRecord::ClassMethods#delay_method
      # @see Timberline::Worker#watch
      def process_item(item)  
        contents = item.contents
        method_name = contents["method_name"]
        model_name = contents["model_name"]
        model_key = contents["model_key"]
        klass = model_name.split('::').reduce(Module, :const_get)
        model = klass.send("find_by_#{klass.primary_key}", model_key) 
        if model.nil?
          # Retry because there may have been a race condition
          item.retry_reason = "Model not found"
          retry_item(item)
        else
          if model.respond_to? "synchronous_#{method_name}"
            model.send("synchronous_#{method_name}")
          elsif model.respond_to? method_name
            model.send(method_name)
          else
            item.error_reason = "Method not found on model"
            error_item(item)
          end
        end
      rescue ItemErrored, ItemRetried => e
        # throw ItemErrored and ItemRetried back up the chain
        raise e
      rescue Exception => e
        item.error_reason = e.message
        item.error_backtrace = e.backtrace
        error_item(item)
      end
    end
  end
end
