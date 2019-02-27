class Invitation < ApplicationRecord
	belongs_to :group

	before_create :generate_token

protected

   def generate_token
    self.invitation_link = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Invitation.exists?(invitation_link: random_token)
    end
  end
end
