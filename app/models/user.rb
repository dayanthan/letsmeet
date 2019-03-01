class User < ApplicationRecord
  has_secure_password
  has_secure_password
  has_many :user_groups
  has_many :groups, through: :user_groups#, dependent: :destroy
  has_many :invitations, :class_name => "Invitation", :foreign_key => 'receiver_id'
  has_many :sent_invites, :class_name => "Invitation", :foreign_key => 'sender_id'
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, :presence => true, :confirmation => true,
                       :length => {:within => 6..40}
  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end
  # before_create :generate_token

protected
	
   def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
  #  def generate_token
  #   self.invitation_link = loop do
  #     random_token = SecureRandom.urlsafe_base64(nil, false)
  #     break random_token unless Group.exists?(invitation_link: random_token)
  #   end
  # end
end
