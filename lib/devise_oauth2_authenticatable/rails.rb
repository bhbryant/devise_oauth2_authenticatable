module Devise
  class Engine
    config.after_initialize do
      Devise::OAUTH2_CONFIG = YAML.load_file(Rails.root.join('config', 'oauth2_config.yml'))[Rails.env]
    end
  end
end