module GroupsHelper
   def pending_requests(group)
   	  @pending_list=Invitation.where("group_id=? AND is_approved=?",group.id, false)
   end
   def pending_user(user)
   	@user=User.find_by_id(user.receiver_id)   	
   end
end
