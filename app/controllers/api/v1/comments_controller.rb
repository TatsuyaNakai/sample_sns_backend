class Api::V1::CommentsController < ApplicationController

    def create
        comment = Comment.new(comment_params)
        comment.user_id = current_user.id
        post = comment.post
        if comment.save
            post.create_notification_comment!(current_user, comment.id)
            render json: {
                comment: comment
            }, status: :ok
        else
            render json: comment.errors, status: 422
        end
    end

    def destroy
        if Comment.destroy(params[:id])
            head :no_content
        else
            render json: { 
                error: "Failed to destroy"
            }, status: 422
        end
    end
    
    private
    def comment_params
        params.require(:comment).permit(:content, :post_id)
    end
    
end
