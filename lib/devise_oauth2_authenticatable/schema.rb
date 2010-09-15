# encoding: utf-8
require 'devise/schema'

module Devise #:nodoc:
  module Oauth2Authenticatable #:nodoc:

    module Schema

      # Database migration schema for Facebook Connect.
      #
      def oauth2_authenticatable
        apply_schema ::Devise.oauth2_uid_field, Integer, :limit => 8  # BIGINT unsigned / 64-bit int
        apply_schema ::Devise.oauth2_token_field, String, :limit => 149  # [128][1][20] chars
      end

    end
  end
end

Devise::Schema.module_eval do
  include ::Devise::Oauth2Authenticatable::Schema
end