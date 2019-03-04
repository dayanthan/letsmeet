class Group < ApplicationRecord
  has_many :user_groups
  has_many :invitations
  has_many :users, through: :user_groups#, dependent: :destroy
  has_many :posts
  validates :name, presence: true, uniqueness: true

end
