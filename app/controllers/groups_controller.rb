class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @group_list = UserGroup.where("user_id =?",session[:user_id]).pluck('group_id');
    @groups = Group.where(:id => @group_list)
  end

  def show
    @user_list = UserGroup.where("group_id =?",params[:id]).pluck('user_id');
    @users = User.where(:id => @user_list)
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.user_id = session[:user_id]
    respond_to do |format|
      if @group.save
        UserGroup.create(:group_id => @group.id, :user_id=>session[:user_id], :is_admin=>true)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_groups=UserGroup.where("group_id=?",@group.id)
    @group.destroy
    @user_groups.destroy_all
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_members
    @group_id = params[:id]
    @group_list = UserGroup.where("group_id =?",params[:id]).pluck('user_id');
    @users = User.where('id NOT IN (?)', @group_list)
  end


  def send_invite
    @user=User.find_by_id(params[:user_id])
    @group=Group.find_by_id(params[:group_id])
    if session[:user_id] == @group.user_id
       is_admin = true
    else
       is_admin = false
    end
    @token = Digest::SHA1.hexdigest([Time.now, rand].join)
    @invitation=Invitation.create(:email => @user.email,:sender_id => session[:user_id],:receiver_id => params[:user_id], :group_id => params[:group_id], :is_approved => is_admin)

     if @invitation.is_approved
            InviteMailer.group_invitaion(@user, @group, @invitation).deliver
            # format.html { redirect_to "/add_members/4", notice: 'Invitation was successfully sent.' }
     else
     end

  end

  def accept_invitation
        @invitation=Invitation.find_by_invitation_link(params[:token])
        @group=Group.find_by_id(@invitation.group_id)
        @user_groups=UserGroup.where("group_id=? AND user_id=?",@invitation.group_id, @invitation[:receiver_id]).last
       if @invitation 
         if !@user_groups
            @new_group=UserGroup.create(:group_id=>@invitation.group_id, :user_id=>@invitation.receiver_id, :is_admin=>false)
            if @new_group
              @group.update_attributes(:limit=> @group.limit + 1)
            end
            flash[:notice] = "successfully added in #{@group.name}"
            redirect_to root_path
         else
          flash[:notice] = "You already in this #{@group.name}"
            redirect_to root_path
         end
     end
  end

  def generate_token
    self.invitation_link = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Group.exists?(invitation_link: random_token)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :token, :status, :limit, :user)
    end

end


