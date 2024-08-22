class FeedChannel < ActionCable::Channel::Base
  extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods

  periodically :update_media, every: 5.seconds

  def subscribed
    if (stream_name = verified_stream_name_from_params).present?
      stream_from stream_name
    else
      reject
    end
  end

  private

  def update_media
    self.class.broadcast_replace_to [connection.current_user.id, "feed"],
      partial: "feed/media",
      target: "media-frame",
      locals: { url: "https://static1.e621.net/data/86/ac/86acad2d06d32791084bcb21ea2e513d.png" }
  end
end