class InviteMailer < ApplicationMailer
	default from: "dayanthan86@gmail.com"

  def group_invitaion(user, group, invitation)
  	@user = user  	
  	@group=group
  	@invitation = invitation
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Group invitation from #{group.name}")
  end
end
