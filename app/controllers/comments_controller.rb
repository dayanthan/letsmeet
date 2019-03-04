class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @comments = Comment.all
  end

  def show
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
     if !params[:comment][:body].nil? && params[:comment][:body].present?
      @comment = Comment.create(:body=>params[:comment][:body],:user_id=>session[:user_id], :post_id=>params[:post_id])
      flash[:notice] = "Comment was successfully added"
      redirect_to all_posts_path
    else
      flash[:error] = "somthing went wrong"
      redirect_to all_posts_path
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body, :user_id, :post_id)
    end
end
