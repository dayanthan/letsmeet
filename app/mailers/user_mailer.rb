class UserMailer < ApplicationMailer
  default from: "dayanthan86@gmail.com"

  def registration_confirmation(user)
  	@user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registration Confirmation")
  end
end
