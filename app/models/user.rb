class User < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :walking_routes, dependent: :destroy

  default_scope { where(is_deleted: false) }
  # scope :with_deleted, -> { unscope(where: :is_deleted) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  def active_for_authentication?
    super && (is_deleted == false)
  end

  mount_uploader :profile_image, AvatarUploader

  with_options presence: true do
    with_options uniqueness: true do
      validates :name, length: { maximum: 20 }
    end
  end

  validates :comment, length: { maximum: 140 }, allow_blank: true
end
