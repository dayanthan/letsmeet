class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @group = Group.find(params[:group_id])
    @posts = Post.where("group_id=?",params[:group_id])
  end

  def all_posts
    @posts = Post.where("is_approved =?",true)
  end

  def show
  end

  def new
    @group = Group.find(params[:group_id])
    @post = @group.posts.new()
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find_by_id(params[:id])
  end

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.create(post_params)
    @post.user_id = session[:user_id]
    @post.is_approved = (@group.user_id==session[:user_id]) ? true :false
    respond_to do |format|
      if @post.save
        format.html { redirect_to group_posts_path(@group), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @group = Group.find(params[:post][:group_id])
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to group_posts_path(@group), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to group_posts_path(@group), notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reply_comments
    @comment_id=params[:id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def submit_reply
    @comment_id=params[:id]
    @reply_comments=ReplyComment.create(:body=>params[:body], :comment_id=>params[:comment_id], :user_id=>session[:user_id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def all_reply_comments
    @all_reply_comments=ReplyComment.where("comment_id=?",params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def post_confirmation
    @group=Group.find_by_id(params[:group_id])
    @post=Post.find_by_id(params[:id])
    @post.update_attributes(:is_approved => true)
    flash[:notice] = "post was approved successfully"
    redirect_to group_posts_path(@group)
  end


  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :description)
    end
end
