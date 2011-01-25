module Devise
  class Oauth2AuthenticatableGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :client_id, :type => :string, :default => "YOUR_APP_API_ID"
    argument :client_key, :type => :string, :default => "YOUR_APP_SECRET_KEY"
    argument :requested_scope, :type => :string, :default => "email,offline_access,publish_stream"
    argument :auth_server, :type => :string, :default => "https://graph.facebook.com"
    argument :authorize_path, :type => :string, :default => "/oauth/authorize"
    argument :access_token_path, :type => :string, :default => "/oauth/access_token"
    desc "Generates a OAuth2 config file for your application. All the parameters are optional."
    
    def generate_oauth2_config
      template 'oauth2_config.yml', File.join(*%w[config oauth2_config.yml])
    end
  end
end
