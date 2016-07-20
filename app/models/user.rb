class User < ApplicationRecord
  #before action
  before_save { self.email=email.downcase }
  before_create :create_activation_digest
  #attribute
  has_many :microposts, dependent: :destroy

  has_many :comments
  has_many :likes,dependent: :destroy

  has_secure_password
  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  #validates
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: 2}, allow_nil: true
  #methos password reset
  def create_reset_digest
    self.reset_token =User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
  end

  #methods activation
  def create_activation_digest
    self.activation_token =User.new_token
    self.active_digest=User.digest(self.activation_token)
  end

  def send_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #
  def feed
    microposts
  end


  #

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def authenticated?(digest_type, remember_token)
    digest=self.send("#{digest_type}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? remember_token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def follow(onther_user)
    active_relationships.create(followed_id: onther_user.id)
  end

  def unfollow(onther_user)
    active_relationships.find_by(followed_id: onther_user.id).destroy
  end

  def following?(onther_user)
    following.include? onther_user
  end

end
