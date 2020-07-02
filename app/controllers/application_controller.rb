class ApplicationController < ActionController::Base
  
  def openweathermap
      request_weather
  end
  
end
