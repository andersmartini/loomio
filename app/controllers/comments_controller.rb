class CommentsController < BaseController
  load_and_authorize_resource

  def destroy
    DiscussionService.delete_comment(comment: @comment, actor: current_user)
    flash[:notice] = t(:"notice.comment_deleted")
    redirect_to discussion_url(@comment.discussion)
  end

  def edit
  end

  def update
    @comment.edit_body!(params[:comment][:body])
    redirect_to @comment.discussion
  end

  def show
  end

  def like
    if params[:like] == 'true'
      Measurement.increment('comments.like.success')
      DiscussionService.like_comment(current_user, @comment)
    else
      Measurement.increment('comments.unlike.success')
      DiscussionService.unlike_comment(current_user, @comment)
    end
    @discussion = @comment.discussion

    render :template => "comments/comment_likes"
  end

end
