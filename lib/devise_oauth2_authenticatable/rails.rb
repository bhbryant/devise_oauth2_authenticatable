module Devise
  class Engine
    config.after_initialize do
      begin
        Devise::OAUTH2_CONFIG = YAML.load_file(Rails.root.join('config', 'oauth2_config.yml'))[Rails.env]
      rescue
        puts "Can't load oauth2_config.yml. You can generate with rails g devise:oauth2_authenticatable"
      end
    end
  end
end