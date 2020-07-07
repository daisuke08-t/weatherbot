class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]
  
  
  CITY = "Tokyo,JP"
  BASE_URL = "https://api.openweathermap.org/data/2.5/"
  
  require "json"
  require "open-uri"
  


  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      if event.message['text'].include?('天気')  #天気の情報を取得する処理
        response = open(BASE_URL + "weather?q=#{CITY}&APPID=#{ENV["OPEN_API_KEY"]}")  
        datas = JSON.parse(response.read)
        @response = "今日の天気です！！\n"
        @response_main = "天気： #{datas["weather"][0]["main"]}\n"
        @response_description = "天気詳細： #{datas["weather"][0]["description"]}\n"
        response_temp = datas["main"]["temp"] - 273.15
        @response_temp = "気温： #{response_temp.round(1)}" + "℃"
        
        @template = @response + @response_main + @response_description + @response_temp
        
      end
      
      
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          
          massage = {
            
            "type": "text",
            "text": @template
            
            
          }
          
          client.reply_message(event['replyToken'], massage)
        end
      end
    }

    head :ok
  end

  
end
