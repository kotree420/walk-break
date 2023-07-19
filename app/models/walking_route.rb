class WalkingRoute < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  belongs_to :user

  with_options presence: true do
    validates :name, length: { maximum: 20 }
    validates :comment, length: { maximum: 140 }
    validates :distance, numericality: true
    validates :duration, numericality: true
    validates :start_address
    validates :end_address
    validates :encorded_path
  end

  def bookmarks_count
    count = []
    bookmarks = self.bookmarks.includes([:user])
    bookmarks.each do |bookmark|
      if bookmark.user
        count << bookmark.user
      end
    end
    count = count.length
  end

  def bookmarked?(user)
    bookmarks.where(user_id: user).exists?
  end
end
