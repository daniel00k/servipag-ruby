require 'yaml'
module ServipagConfiguration
  class Configuration

    def initialize env = nil, filepath = nil, settings = nil
      @@env         ||= env      || Rails.env
      @@filepath    ||= filepath || Rails.root
      @@settings    ||= settings || self.load(File.join(@@filepath, 'config', 'servipag.yml'))[@@env]
    end

    def load(file)
      YAML.load_file file
    end

    def settings
      @@settings
    end
  end
end