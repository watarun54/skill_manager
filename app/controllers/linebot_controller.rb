class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'uri'

  skip_before_action :login_required, only: [:client, :callback]

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

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
          @user = User.find_by(line_user_id: event['source']['userId'])

          if @user.present?
            if register_paper(event)
              status_message = "記事の登録に成功しました"
            else
              status_message = "記事の登録に失敗しました"
            end
            send_message(event, status_message)
          else
            messages = [
              {
                type: 'text',
                text: event['source']['userId']
              },
              {
                type: 'text',
                text: "こちらのIDを「ユーザー編集」->「Line User Id」に登録してください\nhttp://#{HOST}/"
              }
            ]
            client.reply_message(event['replyToken'], messages)
          end
        end
      end
    }
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def send_message(event, status_message)
    message = {
      type: 'text',
      text: status_message
    }
    client.reply_message(event['replyToken'], message)
  end

  def register_paper(event)
    text = event.message['text']
    uri = URI.extract(text)[0]
    URI.extract(text).uniq.each {|url| text.gsub!(url, '')}
    return false if uri.nil?
    text.strip!
    UpdatePapersJob.perform_later(@user.id, text, uri)
    true
  end
end
