class Group < ApplicationRecord
  has_many :user_groups
  has_many :invitations
  has_many :users, through: :user_groups#, dependent: :destroy
  has_many :posts
  validates :name, presence: true, uniqueness: true

  before_create :generate_token

protected

   def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Group.exists?(token: random_token)
    end
  end
end
