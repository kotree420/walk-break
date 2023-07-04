class WalkingRoute < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  belongs_to :user

  validates :name, :comment, :distance, :duration, :start_address, :end_address, :encorded_path,
    presence: true

  def bookmarked?(user)
    bookmarks.where(user_id: user).exists?
  end
end
