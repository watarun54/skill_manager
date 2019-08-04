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
    if text.empty?
      result = request_analyze_paper_api(uri)
      text = result["title"].nil? ? "#Error#タイトルを取得できませんでした。" : result["title"]
    end
    @user.papers.create!(title: text, url: uri)
    true
  end

  def request_analyze_paper_api(url)
    uri = URI.parse(ANALYZE_PAPER_API_URL)
    params = { "url" => url }
    headers = { "Content-Type" => "application/json" }

    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.post(uri.path, params.to_json, headers)
    end

    case response
    when Net::HTTPSuccess
      result = JSON.parse(response.body)
    when Net::HTTPRedirection
      result = { "error" => "Redirection: code=#{response.code} message=#{response.message}" }
    else
      result = { "error" => "HTTP ERROR: code=#{response.code} message=#{response.message}" }
    end
    result
  rescue => e
    { "error" => e.message }
  end
end
