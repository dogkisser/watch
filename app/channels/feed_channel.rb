# TODO: I think this is required, Rails says it doesn't autoinclude stdlib stuff
require "open-uri"

BASE_XP_PER_SEC = 350

class FeedChannel < ActionCable::Channel::Base
  extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods

  periodically :update_media, every: 5.seconds
  periodically :calculate_xp, every: 1.second

  def subscribed
    if (stream_name = verified_stream_name_from_params).present?
      stream_from stream_name
    else
      reject
    end
  end

  # TODO: put most of this stuff in helpers
  private

  # TODO: I don't like that an overloaded server could reduce XP rate
  # score should be calculated from a delta
  def calculate_xp
    added_xp = BASE_XP_PER_SEC
    connection.current_user.xp += added_xp.to_i
    
    new_level = xp_to_level(connection.current_user.xp)
    percent = "#{(new_level.modulo(1) * 100).floor}%"

    puts "User #{connection.current_user.username} has #{connection.current_user.xp} xp"

    # TODO: Not commit the model every single second. Maybe every 5 minutes.
    connection.current_user.save!
    self.class.broadcast_update_to [connection.current_user.id, "feed"],
      partial: "feed/xp",
      target: "xp-frame",
      locals: { percent: percent }
  end

  # Converts a level into the amount of XP necessary to reach it.
  def level_to_xp(level)
    (1250 * level.pow(2)) + (8750 * level)
  end

  # Converts an amount of XP into the user's current level as a float, where the fractional part
  # represents the users progression through the level.
  def xp_to_level(xp)
    Math.sqrt((xp.fdiv(1250) + 12.25)) - 3.5
  end

  def update_media
    # url = get_post_cached("feral")
    url = "https://static1.e621.net/data/sample/ce/9f/ce9fca65626fa0a875d2c21b8a37588b.jpg"

    self.class.broadcast_update_to [connection.current_user.id, "feed"],
      partial: "feed/media",
      target: "media-frame",
      locals: { url: url }
  end

  def get_post_cached(fetish)
    linx = Rails.cache.read(fetish)

    if !linx&.length&.>(200)
      logger.info "Refilling post cache for tag '#{fetish}'"

      req = URI.open("https://e621.net/posts.json?tags=order:random+#{fetish}+score:>500&limit=320",
        "User-Agent" => "watch.horse.wang"
      ).read
      urls = JSON.parse(req)["posts"].map { _1["sample"]["url"] }.compact

      res = urls.pop
      Rails.cache.write(fetish, Array.wrap(linx) + urls)

      res
    else
      res = linx.pop
      Rails.cache.write(fetish, linx)

      res
    end
  end
end