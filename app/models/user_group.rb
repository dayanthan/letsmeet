class UserGroup < ApplicationRecord
	has_many :invitations
	belongs_to :user
	belongs_to :group
end
