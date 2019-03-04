module CommentsHelper

	def all_comments(id)
		@comments=Comment.where("post_id=?",id)
	end

	def find_user(comment)
		@user=User.find_by_id(comment.user_id)
	end
	
	def total_replies(comment)
		@all_replies=ReplyComment.where("comment_id=?", comment.id)
	end
	
end
