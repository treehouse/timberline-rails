require 'active_job'

ActiveJob::Base.logger = nil
ActiveJob::Base.queue_adapter = :timberline

module SpecSupport
  module FakeRails
    def self.create_fake_env
      fake_rails = OpenStruct.new(root: File.join(File.dirname(File.path(__FILE__)), "..", "fake_rails"), env: "development") 
      Object.send(:const_set, :Rails, fake_rails)
    end

    def self.create_fake_env_without_config
      fake_rails = OpenStruct.new(root: File.join(File.dirname(File.path(__FILE__)), "..", "gibberish"), env: "development") 
      Object.send(:const_set, :Rails, fake_rails)
    end

    def self.destroy_fake_env
      Object.send(:remove_const, :Rails)
    end

    class FakeJob < ActiveJob::Base
      queue_as :fake_queue

      def perform(*args)
      end
    end

    class FakeModel
      include Timberline::Rails::ActiveRecord

      timberline_queue "fake_queue"

      def self.primary_key
        "id"
      end

      def self.find_by_id(id)
        FakeModel.new
      end

      def id
        1
      end

      def some_method
        # left blank
      end
      delay_method :some_method

      def some_other_method
        # left blank
      end
    end
  end
end
