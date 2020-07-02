class LinebotController < ApplicationController
  
  before_action :openweathermap, only: [:clallback]
  
  require 'line/bot'

  protect_from_forgery :except => [:callback]

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
        response = "今日の天気は#{@today_weather}です!!"
      end
      
      
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          
          massage = {
            type: 'text',
            text: response
          }
          # LINEから送られてきたメッセージが「アンケート」と一致するかチェック
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
