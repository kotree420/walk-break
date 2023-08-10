class User < ApplicationRecord
  has_many :bookmarks, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :walking_routes, dependent: :destroy
  has_many :bookmarked_walking_routes, through: :bookmarks, source: :walking_route

  default_scope { where(is_deleted: false) }

  scope :latest, -> { order(created_at: :desc) }
  # ユーザー管理機能で全てのユーザーを取得する場合は以下のunscopeを使う
  scope :with_deleted, -> { unscope(where: :is_deleted) }

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

  validates :comment, with_line_break: { maximum: 140 }, allow_blank: true

  def self.guest
    name = SecureRandom.alphanumeric(10)
    email = "#{name}@example.com"
    comment = "こちらに自己紹介を記載できます。現在はゲストユーザーでログイン中のため編集不可です。"
    password = SecureRandom.urlsafe_base64
    User.create({ name: name, email: email, comment: comment, password: password })
  end

  def bookmarked?(bookmarks, current_user_id)
    bookmarks.pluck(:user_id).include?(current_user_id)
  end

  def self.search(keyword)
    if keyword.present?
      where('name LIKE ?', "%#{keyword}%")
    else
      all
    end
  end
end
