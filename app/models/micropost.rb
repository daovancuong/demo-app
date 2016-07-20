class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes,dependent: :destroy
  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc) }
  validates :content, length: {maximum: 140}, presence: true
  validates :user_id, presence: true
  validates :title, presence: true
  validate :picture_size
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
