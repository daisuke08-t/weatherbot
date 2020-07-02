class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]
  
  #before_action :openweathermap
  
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
      if event.message['text'].include?('天気')
        response = open(BASE_URL + "weather?q=#{CITY}&APPID=#{ENV["OPEN_API_KEY"]}")
        datas = JSON.parse(response.read)
        @today_weather = datas["weather"][0]["description"]
        @response = "今日の天気です！！"
        @response_main = "天気： #{datas["weather"][0]["main"]}"
        @response_description = "天気詳細： #{datas["weather"][0]["description"]}"
        @response_icon = "http://openweathermap.org/img/w/#{datas["weather"][0]["icon"]}"
        response_temp = datas["main"]["temp"] - 273.15
        @response_temp = response_temp.round(1) + "℃"
        
      end
      
      
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          
          massage = {
            
            "contens": [
              
              {"type": "text",
              "text": @response},
              
              {"type": "text",
              "text": @response_main},
            
              {"type": "text",
              "text": @response_description},
            
              {"type": "image",
              "originalContentUrl": @response_icon,
              "previewImageUrl": @response_icon},
          
            
              {"type": 'text',
              "text": @response_temp}
              
              ]
            
            
            
          }
          
          client.reply_message(event['replyToken'], massage)
        end
      end
    }

    head :ok
  end

  private

  # def template
  #   {
  #     "type": "template",
  #     "altText": "this is a confirm template",
  #     "template": {
  #         "type": "confirm",
  #         "text": "今日の天気はです！！",
  #         "actions": [
  #             {
  #               "type": "message",
  #               # Botから送られてきたメッセージに表示される文字列です。
  #               "label": "Happy",
  #               # ボタンを押した時にBotに送られる文字列です。
  #               "text": "Happy"
  #             },
  #             {
  #               "type": "message",
  #               "label": "So so...",
  #               "text": "So so..."
  #             }
  #         ]
  #     }
  #   }
  # end
  
  
  
  
end
