class Timberline
  class Rails
    # Raised when Timberline::Rails::ActiveRecord is included in a
    # model that does not implement required functionality.
    # @see Timberline::Rails::ActiveRecord
    class InvalidModelError < StandardError; end
  end
end
