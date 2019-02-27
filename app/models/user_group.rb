class UserGroup < ApplicationRecord
	has_many :invitations
	belongs_to :user
	belongs_to :group
	# before_save :check_group_limit, :if => UserGroup.count <= 257
end
