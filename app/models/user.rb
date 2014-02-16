class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :email, length: { maximum: 254 }
  validates :username, length: { maximum: 50 }
  validate  :email_or_username,
            :email_requirements,
            :username_requirements

  has_many :addresses

  # Used for allowing username or email address for registration with Devise
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # So Devise knows this field is optional
  def email_required?
    false
  end

  private

  def email_or_username
    if self.email.blank? && self.username.blank?
      errors.add(:base, 'Email or username is required')
    end
  end

  def email_requirements
    if self.email.present? && self.email.length > 0
      if self.email.length < 5
        errors.add(:email, 'is too short (minimum is 5 characters)')
      end
    else
      self.email = nil
    end
  end

  def username_requirements
    if self.username.present? && self.username.length > 0
      if self.username.length < 3
        errors.add(:username, 'is too short (minimum is 3 characters)')
      end
      if User.where("lower(username) = ?", self.username.downcase).any?
        errors.add(:username, 'is already taken')
      end
    else
      self.username = nil
    end
  end

end
