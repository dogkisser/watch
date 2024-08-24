class Session
  include ActiveModel::Model

  attr_accessor :username, :password

  validates :username, presence: true
  validates :password, presence: true
  validate :user_actually_exists

  delegate :id, to: :user, allow_nil: true

  def user
    User.authenticate_by(username:, password:)
  end

  private

  def user_actually_exists
    errors.add(:base, "User doesn't exist or your entered the wrong password") unless user.present?
  end
end