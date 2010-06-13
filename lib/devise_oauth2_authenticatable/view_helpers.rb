# encoding: utf-8
require 'devise/mapping'

module Devise #:nodoc:
  module Oauth2Authenticatable #:nodoc:

    # OAuth2 view helpers to easily add the link to the OAuth2 connection popup and also the necessary JS code.
    #
    module Helpers
      
      # Creates the link to 
      def link_to_oauth2(link_text, options={})
        
        
        session_sign_in_url = Devise::session_sign_in_url(request,::Devise.mappings[:user])
      
        link_to link_text, Devise::oauth2_client.web_server.authorize_url(
            :redirect_uri => session_sign_in_url,  
            :scope => Devise::requested_scope
          ), options
      end


      
    end
  end
end

::ActionView::Base.send :include, Devise::Oauth2Authenticatable::Helpers