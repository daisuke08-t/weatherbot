Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get '/' => 'home#index'
  
  #get '/weather' => 'weather#index'
  
  post '/callback' => 'linebot#callback'  
  
  #post '/request_weather' => 'weather#request_weather'
  
  
end
