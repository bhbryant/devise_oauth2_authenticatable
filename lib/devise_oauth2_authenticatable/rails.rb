module Devise
  class Engine
    config.after_initialize do
      begin
        oauth2_config_yml = Rails.root.join('config', 'oauth2_config.yml')
        Devise::OAUTH2_CONFIG = File.exists?(oauth2_config_yml) ? YAML.load_file(oauth2_config_yml)[Rails.env] : {}


        Devise::OAUTH2_CONFIG.merge!({"client_id" => ENV['FB_CLIENT_ID'] }) if ENV['FB_CLIENT_ID']
        Devise::OAUTH2_CONFIG.merge!({"client_secret" => ENV['FB_CLIENT_SECRET'] }) if ENV['FB_CLIENT_SECRET']
        Devise::OAUTH2_CONFIG.merge!({"authorization_server" => ENV['FB_AUTH_URL'] }) if ENV['FB_AUTH_URL']
        Devise::OAUTH2_CONFIG.merge!({"requested_scope" => ENV['FB_SCOPE'] }) if ENV['FB_SCOPE']
        
        
        raise "OAUTH2_CONFIG.client_id not specified" unless Devise::OAUTH2_CONFIG.has_key? "client_id"
        raise "OAUTH2_CONFIG.client_secret not specified" unless Devise::OAUTH2_CONFIG.has_key? "client_secret"
        raise "OAUTH2_CONFIG.authorization_server not specified" unless Devise::OAUTH2_CONFIG.has_key? "authorization_server"
      rescue
        puts "Can't load oauth2_config.yml. You can generate with rails g devise:oauth2_authenticatable"
      end
    end
  end
end