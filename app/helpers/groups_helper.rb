module GroupsHelper
	def check_user_stauts(id)
      p id
      p @status= (session[:user_id]==id)
   end
end
