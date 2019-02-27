class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  # before_action :current_user
  def index
    @groups = Group.where("user_id=?",session[:user_id])
  end

  def show
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
    @groups = Group.where("user_id=?",session[:user_id])
    @users = User.where("id!=?", session[:user_id])
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


