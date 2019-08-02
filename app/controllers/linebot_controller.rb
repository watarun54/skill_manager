class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'uri'

  skip_before_action :login_required, only: [:client, :callback]

  # callbackアクションのCSRFトークン認証を無効
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
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if register_paper(event)
            status_message = "登録に成功しました"
          else
            status_message = "登録に失敗しました"
          end
          message = {
            type: 'text',
            text: status_message
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }
    head :ok
  end

  private

  def register_paper(event)
    user = User.last
    text = event.message['text']
    uri = URI.extract(text)[0]
    URI.extract(text).uniq.each {|url| text.gsub!(url, '')}
    if uri.nil?
      false
    else
      user.papers.create!(title: text.strip, url: uri)
      true
    end
  end
end
