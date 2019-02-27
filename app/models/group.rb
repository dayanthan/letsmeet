class Group < ApplicationRecord
  has_many :usergroup
  has_many :invitations
  has_many :users, through: :usergroup#, dependent: :destroy

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
