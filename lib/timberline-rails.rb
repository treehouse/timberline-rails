require 'timberline'
require 'timberline/rails/version'

class Timberline
  class Config
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
