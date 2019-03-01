class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @group = Group.find(params[:group_id])
    @posts = Post.where("group_id=?",params[:group_id])
  end

  def all_posts
    @posts = Post.all
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :description)
    end
end
