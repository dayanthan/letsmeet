module CommentsHelper
	def all_coments(id)
		# p id
		 # d = Comment.includes(:user).where('users.user_id' => true)

		@comments=Comment.where("post_id=?",id)
		# sp @comments.count
	end
end
