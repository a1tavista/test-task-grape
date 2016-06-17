class Account < ActiveRecord::Base
  has_secure_password
  belongs_to :profile, polymorphic: true
  has_many :comments
  validates :login, :profile_id, :profile_type, presence: true

  scope :customers, -> { where(profile_type: 'Customer') }
  scope :admins, -> { where(profile_type: 'Admin') }

  def admin?
    profile_type == 'Admin'
  end

  def customer?
    profile_type == 'Customer'
  end

  def self.authorize!(token)
    decoded_token = JWT.decode(token,
                               Rails.configuration.x.jwt_salt,
                               true,
                               { :leeway => Rails.configuration.x.jwt_leeway_time, :algorithm => 'HS256' })
    find_by_id(decoded_token[0]['id'])
  end

end
