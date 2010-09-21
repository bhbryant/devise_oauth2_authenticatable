module Devise #:nodoc:
  module Oauth2Authenticatable #:nodoc:
    module SessionsControllerExtension
      def self.included?(klass)
      end
      

            
      #prepend_before_filter :require_no_authentication, :only => [ :new, :create, :oauth_callback ]
     def oauth_callback 
       
       puts "HERE"
       @errors = params[:error] if params.has_key?(:error)
        if resource = authenticate(resource_name)
          set_flash_message :notice, :signed_in
          
        else 
          set_flash_message :notice, (@errors && @errors[:message])  || "failure"
        end
        render "oauth_callback", :layout => false
      end
          
      
       # GET /resource/sign_out
      def destroy
        set_flash_message :notice, :signed_out if signed_in?(resource_name)
        
        puts "HERE"
        if request.xhr? 
          sign_out(resource_name)
          render "oauth_logout", :layout => false
        else
           sign_out(resource_name)
           #_and_redirect(resource_name)
           render "oauth_logout", :layout => false
        end
        
      end
      
      
    end
  end
end

