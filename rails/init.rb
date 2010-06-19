# encoding: utf-8
Devise::OAUTH2_CONFIG = YAML.load_file(Rails.root.join('config', 'oauth2_config.yml'))[Rails.env]

require 'devise_oauth2_authenticatable'