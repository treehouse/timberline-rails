class Timberline
  class Rails
    # Timberline::Rails::ActiveRecord will add some extra logic
    # to your ActiveRecord models so that you can quickly and
    # easily defer certain methods to background processing.
    #
    # Although this module is primarily intended for use with
    # ActiveRecord models, it will actually work with any class
    # that implements the following methods:
    # - primary_key - a method that returns a String representing the
    #   primary_key for this model (for ActiveRecord this is usually "id")
    # - find_by_[primary_key] - a method that returns an object matching
    #   the specified primary key, or nil if it does not exist (e.g. "find_by_id")
    #
    # @see Timberline::Rails::ActiveRecordWorker
    #
    # @example using Timberline::Rails::ActiveRecord to process an email in the background
    #   class User < ActiveRecord::Base
    #     include Timberline::Rails::ActiveRecord
    #
    #     timberline_queue "users"
    #     
    #     def send_some_email
    #       # do stuff to send the email
    #     end
    #     delay_method :send_some_email
    #   end
    #
    module ActiveRecord
      def self.included(klass)
        klass.class_eval do
          extend Timberline::Rails::ActiveRecord::ClassMethods  
        end
      end
      
      # Class methods that get added to any class that includes Timberline::Rails::ActiveRecord.
      #
      module ClassMethods
        # Set the queue name for this model. Required.
        # @param [String] queue_name the name of the queue that this model will use
        #   to process jobs.
        #
        def timberline_queue(queue_name)
          @timberline_queue = Timberline.queue(queue_name)
        end

        # Push an item onto the queue specified for this model.
        # @see delay_method
        #
        def timberline_push(content, metadata = {})
          if @timberline_queue.nil?
            raise "You must specify a queue name using .timberline_queue first"
          end
          @timberline_queue.push(content, metadata)
        end

        # Mark a method as one that needs to be executed in the background.
        # @param [Symbol, String] method_name the name of the method to execute in the background.
        #   This method will be aliased to synchronous_[method_name] in the event
        #   that it needs to be called directly.
        #
        def delay_method(method_name)
          alias_method "synchronous_#{method_name}", method_name
          define_method "timberline_#{method_name}" do 
            model_name = self.class.name
            model_key = self.send(self.class.primary_key)
            self.class.timberline_push({ model_name: model_name, 
                                         model_key: model_key, 
                                         method_name: method_name })
          end
          alias_method method_name, "timberline_#{method_name}"
        end
      end
    end
  end
end
