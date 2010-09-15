# encoding: utf-8

class DeviseOauth2AuthenticatableGenerator < Rails::Generator::Base #:nodoc:

  default_options :client_id => "YOUR_APP_API_ID",
                  :client_key => "YOUR_APP_SECRET_KEY",
                  :auth_server => "https://graph.facebook.com",
                  :requested_scope => "email,offline_access,publish_stream"

  def manifest
    record do |m|
     # m.dependency 'xd_receiver', [], options.merge(:collision => :skip)
      m.template 'oauth2_config.yml', File.join(*%w[config oauth2_config.yml])
    #  m.template 'devise.facebook_connectable.js', File.join(*%w[public javascripts devise.facebook_connectable.js])
    end
  end

  protected

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'

      opt.on('--id CLIENT_ID', "Application API ID.") do |v|
        options[:client_id] = v if v.present?
      end

      opt.on('--key SECRET_KEY', "Application Secret key.") do |v|
        options[:client_key] = v if v.present?
      end
      opt.on('--server AUTH_SERVER', "Authentication Server.") do |v|
        options[:auth_server] = v if v.present?
      end
      opt.on('--resources REQUESTED_RESOURCES', "Requested Resources.") do |v|
        options[:requested_scope] = v if v.present?
      end
    end
    

    def banner
      "Usage: #{$0} devise_oauth2_authenticatable [--id API_ID] [--key SECRET_KEY] [--server AUTH_SERVER] [--scope REQUESTED RESOURCES]"
    end

end