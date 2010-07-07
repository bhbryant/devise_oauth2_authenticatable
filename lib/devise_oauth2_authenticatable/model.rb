# encoding: utf-8
require 'devise/models'


module Devise #:nodoc:
  # module OAuth2Authenticatable #:nodoc:
    module Models #:nodoc:

      # OAuth2 Connectable Module, responsible for validating authenticity of a
      # user and storing credentials while signing in using their OAuth2 account.
      #
      # == Configuration:
      #
      # You can overwrite configuration values by setting in globally in Devise (+Devise.setup+),
      # using devise method, or overwriting the respective instance method.
      #
      # +oauth2_uid_field+ - Defines the name of the OAuth2 user UID database attribute/column.
      #
      # +oauth2_token_field+ - Defines the name of the OAuth2 session key database attribute/column.
      #
      # +oauth2_auto_create_account+ - Speifies if account should automatically be created upon connect
      #                                 if not already exists.
      #
      # == Examples:
      #
      #    User.oauth2_connect(:uid => '123456789')     # returns authenticated user or nil
      #    User.find(1).oauth2_connected?               # returns true/false
      #
      module Oauth2Authenticatable

        def self.included(base) #:nodoc:
          base.class_eval do
            extend ClassMethods
          end
        end

        # Store OAuth2 Connect account/session credentials.
        #
        def store_oauth2_credentials!(attributes = {})
          self.send(:"#{self.class.oauth2_uid_field}=", attributes[:uid])
          self.send(:"#{self.class.oauth2_token_field}=", attributes[:token])

          # Confirm without e-mail - if confirmable module is loaded.
          self.skip_confirmation! if self.respond_to?(:skip_confirmation!)

          # Only populate +email+ field if it's available (e.g. if +authenticable+ module is used).
          self.email = attributes[:email] || '' if self.respond_to?(:email)

          # Lazy hack: These database fields are required if +authenticable+/+confirmable+
          # module(s) is used. Could be avoided with :null => true for authenticatable
          # migration, but keeping this to avoid unnecessary problems.
          self.password_salt = '' if self.respond_to?(:password_salt)
          self.encrypted_password = '' if self.respond_to?(:encrypted_password)
        end

        # Checks if OAuth2 Connected.
        #
        def oauth2_connected?
          self.send(:"#{self.class.oauth2_uid_field}").present?
        end
        alias :is_oauth2_connected? :oauth2_connected?

        # Hook that gets called *before* connect (only at creation). Useful for
        # specifiying additional user info (etc.) from OAuth2.
        #
        # Default: Do nothing.
        #
        # == Examples:
        #
        #   # Overridden in OAuth2 Connect:able model, e.g. "User".
        #   #
        #   def before_oauth2_auto_create(oauth2_user_attributes)

        #     self.profile.first_name = oauth2_user_attributes.first_name

        #
        #   end
        #
        # == For more info:
        #
        #   * http://oauth2er.pjkh.com/user/populate
        #
        def on_before_oauth2_auto_create(oauth2_user_attributes)
          
          if self.respond_to?(:before_oauth2_auto_create)
            self.send(:before_oauth2_auto_create, oauth2_user_attributes) rescue nil
          end
        end

        # Hook that gets called *after* a connection (each time). Useful for
        # fetching additional user info (etc.) from OAuth2.
        #
        # Default: Do nothing.
        #
        # == Example:
        #
        #   # Overridden in OAuth2 Connect:able model, e.g. "User".
        #   #
        #   def after_oauth2_connect(oauth2_user_attributes)
        #     # See "on_before_oauth2_connect" example.
        #   end
        #
        def on_after_oauth2_connect(oauth2_user_attributes)
          
          if self.respond_to?(:after_oauth2_connect)
            self.send(:after_oauth2_connect, oauth2_user_attributes) rescue nil
          end
        end

        # Optional: Store session key.
        #
        def store_session(using_token)
          if self.token != using_token
            self.update_attribute(self.send(:"#{self.class.oauth2_token_field}"), using_token)
          end
        end
      
      protected

      # Passwords are always required if it's a new rechord and no oauth_id exists, or if the password
      # or confirmation are being set somewhere.
      def password_required?
        
        ( new_record? && oauth2_uid.nil? ) || !password.nil? || !password_confirmation.nil?
      end

        module ClassMethods

          # Configuration params accessible within +Devise.setup+ procedure (in initalizer).
          #
          # == Example:
          #
          #   Devise.setup do |config|
          #     config.oauth2_uid_field = :oauth2_uid
          #     config.oauth2_token_field = :oauth2_token
          #     config.oauth2_auto_create_account = true
          #   end
          #
          ::Devise::Models.config(self,
              :oauth2_uid_field,
              :oauth2_token_field,
              :oauth2_auto_create_account
            )

          # Alias don't work for some reason, so...a more Ruby-ish alias
          # for +oauth2_auto_create_account+.
          #
          def oauth2_auto_create_account?
            self.oauth2_auto_create_account
          end

          # Authenticate a user based on OAuth2 UID.
          #
          def authenticate_with_oauth2(oauth2_id, oauth2_token)
            
              # find user and update access token 
              returning(self.find_for_oauth2(oauth2_id)) do |user|
                user.update_attributes(:oauth2_token => oauth2_token) unless user.nil?
              end

          end

          protected

          

            # Find first record based on conditions given (OAuth2 UID).
            # Overwrite to add customized conditions, create a join, or maybe use a
            # namedscope to filter records while authenticating.
            #
            # == Example:
            #
            #   def self.find_for_oauth2(uid, conditions = {})
            #     conditions[:active] = true
            #     self.find_by_oauth2_uid(uid, :conditions => conditions)
            #   end
            #
            def find_for_oauth2(uid, conditions = {})
              
              self.find_by_oauth2_uid(uid, :conditions => conditions)
            end
            
            

            # Contains the logic used in authentication. Overwritten by other devise modules.
            # In the OAuth2 Connect case; nothing fancy required.
            #
            def valid_for_oauth2(resource, attributes)
              true
            end

        end

      end
    end
  # end
end