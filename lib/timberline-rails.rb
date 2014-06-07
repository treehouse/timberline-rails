require 'timberline'
require 'timberline/rails/version'
require 'timberline/rails/exceptions'
require 'timberline/rails/active_record'
require 'timberline/rails/active_record_worker'

class Timberline
  # Re-open the Timberline::Config class from Timberline
  class Config
    # Load config/timberline.yml from the Rails root if it exists.
    # If it doesn't, or if we're somehow not in a Rails application,
    # just use the default Timberline behavior for instantiating
    # Config objects.
    def rails_initialize
      if defined? ::Rails
        config_file = File.join(::Rails.root, 'config', 'timberline.yml')
        if File.exists?(config_file)
          configs = YAML.load_file(config_file)
          config = configs[::Rails.env]
          load_from_yaml(config)
        else
          non_rails_initialize
        end
      else
        non_rails_initialize
      end
    end

    alias_method :non_rails_initialize, :initialize
    alias_method :initialize, :rails_initialize
  end
end
