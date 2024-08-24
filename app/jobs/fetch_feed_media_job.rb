class FetchFeedMediaJob < ApplicationJob
  queue_as :default

  def perform(fetish)
    cur = Rails.cache.read(fetish)

    if cur.length < 200
      url = URI.parse "https://e621.net/posts.json?tags=order:random&#{fetish}&limit=320"
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      urls = JSON.parse(res)[:posts].map { |p| p.sample&.url || p.file.url }

      Rails.cache.write(fetish, cur + urls)
    end
  end
end