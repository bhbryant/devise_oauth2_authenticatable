# encoding: utf-8
require 'devise/strategies/base'


module Devise #:nodoc:
  module Oauth2Authenticatable #:nodoc:
    module Strategies #:nodoc:

      # Default strategy for signing in a user using Facebook Connect (a Facebook account).
      # Redirects to sign_in page if it's not authenticated
      #
      class Oauth2Authenticatable < ::Devise::Strategies::Base
        
        

        # Without a oauth session authentication cannot proceed.
        #
        def valid?
          
         valid_controller? && valid_params? && mapping.to.respond_to?('authenticate_with_oauth2') 
          
        end

        # Authenticate user with OAuth2 
        #
        def authenticate!
          klass = mapping.to
          begin


          #query_params = params.has_key?(:popup) ? "popup=#{params[:popup]}" : nil
          callback_url = URI.parse(URI.escape(request.url, /\|/))
          callback_url.query = params.has_key?(:popup) ? "popup=#{params[:popup]}" : nil
        
        # Verify User Auth code and get access token from auth server: will error on failue
        access_token = Devise::oauth2_client.web_server.get_access_token( 
          params[:code], 
          :redirect_uri => callback_url.to_s
        )
               

=begin

            query_params = params.has_key?(:popup) ? "popup=#{params[:popup]}" : nil
            sign_in_url =   Devise::session_sign_in_url(request, mapping, query_params)
            # Verify User Auth code and get access token from auth server: will error on failue
            access_token = Devise::oauth2_client.web_server.get_access_token(
                params[:code], :redirect_uri => sign_in_url
                  )
                  
=end                
                  
                  
            # retrieve user attributes     
            
            # Get user details from OAuth2 Service    
            # NOTE: Facebook Graph Specific
            # TODO: break this out into separate model or class to handle 
            # different oauth2 providers
            oauth2_user_attributes = JSON.parse(access_token.get('/me')) 
      
            user = klass.authenticate_with_oauth2(oauth2_user_attributes['id'], access_token.token)



            if user.present?
              user.on_after_oauth2_connect(oauth2_user_attributes)
              success!(user)
            else
              if klass.oauth2_auto_create_account?
                
                
                
                user = returning(klass.new) do |u|
                  u.store_oauth2_credentials!(
                      :token => access_token.token,
                      :uid => oauth2_user_attributes['id']
                    )
                  u.on_before_oauth2_auto_create(oauth2_user_attributes)
                end

                begin
                  
                  
                  user.save
                  user.on_after_oauth2_connect(oauth2_user_attributes)
                  
                  
                  success!(user)
                rescue
                  fail!(:oauth2_invalid)
                end
              else
                fail!(:oauth2_invalid)
              end
            end
          
          rescue => e
            fail!(e.message)
          end
        end
        

        
        
        protected
          def valid_controller?
            params[:controller] == 'sessions'
          end

          def valid_params?
            params[:code].present?
          end

      end
    end
  end
end

Warden::Strategies.add(:oauth2_authenticatable, Devise::Oauth2Authenticatable::Strategies::Oauth2Authenticatable)