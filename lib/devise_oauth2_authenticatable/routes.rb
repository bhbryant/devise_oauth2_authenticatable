# encoding: utf-8

ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    # Setup routes for +OAuth2SessionsController+.
    #
 #   alias :oauth2_authenticatable :database_authenticatable


    # Setup routes for +OAuth2SessionsController+.
    #
    def oauth2_authenticatable(routes, mapping)
            
      database_authenticatable(routes, mapping)
      routes.oauth_callback ::Devise.oauth2_callback_path, :controller => 'sessions', :action => 'oauth_callback'
    end

end