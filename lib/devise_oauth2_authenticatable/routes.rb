ActionDispatch::Routing::Mapper.class_eval do
  protected
  
  def devise_oauth2(mapping, controllers)
    get mapping.path_names[:oauth2],  :to => "#{controllers[:sessions]}#oauth_callback", :as => :"oauth2_#{mapping.name}_session"
  end
end
