class WeatherController < ApplicationController
  
  protect_from_forgery :except => [:request_weather]
  
    CITY = "Tokyo,JP"
    BASE_URL = "https://api.openweathermap.org/data/2.5/"
    
    require "json"
    require "open-uri"
  
  def request_weather
    response = open(BASE_URL + "weather?q=#{CITY}&APPID=#{ENV["OPEN_API_KEY"]}")
    @datas = JSON.pretty_generate(JSON.parse(response.read))
  end
  
  def index
    request_weather
  end
  
  
end
