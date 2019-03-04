module PostsHelper
	def post_creator(post)
		@group_owner=Group.where("id=? AND user_id=?", post.group_id, session[:user_id])
		@same_user = (post.user_id==session[:user_id])? true : false 
	 	@post_created_user= Group.where("user_id=?", session[:user_id])
		@post_owner= (@group_owner.count>0 || @same_user)? true : false 
	end
end
