# CITY = "Tokyo,JP"
# BASE_URL = "https://api.openweathermap.org/data/2.5/"

# require "json"
# require "open-uri"

# response = open(BASE_URL + "weather?q=#{CITY}&APPID=#{OPEN_API_KEY}")
# data = JSON.pretty_generate(JSON.parse(response.read))

# today_weather = data["weather"][0]["description"]