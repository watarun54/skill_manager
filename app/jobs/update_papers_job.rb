class UpdatePapersJob < ApplicationJob
  queue_as :default

  def perform(user_id, text, uri)
    logger = Rails.application.config.update_papers_logger

    user = User.find(user_id)

    if text.empty?
      result = request_analyze_paper_api(uri)
      text = result["title"].blank? ? "#ERROR# タイトルを取得できませんでした" : result["title"]
    end

    paper = Paper.where(user_id: user_id, url: uri, title: nil).last
    if paper.nil?
      user.papers.create!(title: text, url: uri)
    else
      paper.update!(title: text)
    end

    logger.info("[Paper updated] user_id: #{user.id}, title: #{text}, url: #{uri}, error: #{result["error"]}, time: #{Time.now}")
  rescue => e
    logger.info("[Paper updated] user_id: #{user.id}, title: #{text}, url: #{uri}, error: #{e.message}, time: #{Time.now}")
  end

  private

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
