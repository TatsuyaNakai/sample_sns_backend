class Api::V1::LikesController < ApplicationController

    def index
        # post_idだけを配列で返却する。
        user_liked_post_ids = current_user.likes.pluck(:post_id)
        render json: {
            likes: user_liked_post_ids
        }, status: :ok
    end
    

    def create
        # ログインしてるユーザーのいいねが存在していなければ以下を実行する。
        unless current_user.likes.exists?(post_id: params[:post_id])
            like = current_user.likes.create(post_id: params[:post_id])
            # post = like.post    でもコードとして通らない？検証する。
            post = Post.find(params[:post_id])
            post.create_notification_like!(current_user)
            render json: { }, status: :ok
        end
    end
    
    def destroy
        like = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
        if current_user.likes.exists?(post_id: params[:post_id])
            if like.destroy
                render json: { }, status: :ok
            else
                render json: { 
                    error: "Failed to destroy"
                }, status: 422
            end
        end
    end
    
end
