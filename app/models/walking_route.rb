class WalkingRoute < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  belongs_to :user

  validates :name, :comment, :distance, :duration, :start_address, :end_address, :encorded_path,
    presence: true

  def bookmarks_count
    count = []
    bookmarks = self.bookmarks.includes([:user])
    bookmarks.each do |bookmark|
      if bookmark.user
        count << bookmark.user
      end
    end
    count = count.length
    return count
  end

  def bookmarked?(user)
    bookmarks.where(user_id: user).exists?
  end
end
