class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  embeds_one :preference
  has_many :posts
  has_many :comments
  has_many :friendships, class_name: "Friendship", inverse_of: :requester
  has_many :inverse_friendships, class_name: "Friendship", inverse_of: :acceptor
 
  accepts_nested_attributes_for :preference #, :dependent => :destroy , :autosave => true
  validates_associated :preference
  mount_uploader :avatar, AvatarUploader

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  field :last_name, type: String
  field :first_name, type: String
  field :email, type: String
  field :about_me, type: String
  field :password, type: String
  field :password_digest, type: String
  field :remember_token, type: String
  field :admin, type: Mongoid::Boolean, default: false

  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def name
    first_name + " " + last_name
  end

  def get_avatar
    if self.avatar.present?
      ActionController::Base.helpers.image_tag(self.avatar.url, :class => 'avatar')
    else
      ActionController::Base.helpers.image_tag("missing_avatar.jpg", :class => 'avatar')
    end
  end

  def get_avatar_path
    if self.avatar.present?
      ActionController::Base.helpers.image_path(self.avatar.url, :class => 'avatar')
    else
      ActionController::Base.helpers.image_path("missing_avatar.jpg", :class => 'avatar')
    end
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
