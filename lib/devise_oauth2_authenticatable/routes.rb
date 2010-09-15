# encoding: utf-8

ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    # Setup routes for +OAuth2SessionsController+.
    #
    alias :oauth2_authenticatable :database_authenticatable

end