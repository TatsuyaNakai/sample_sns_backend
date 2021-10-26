class Api::V1::RelationshipsController < ApplicationController

    # 相手をフォローしてるか見る確認するため、
    def index
        followings_ids = current_user.relationships.pluck(:follow_id)
        render json: {
            followings: followings_ids
        }, status: :ok
    end

    def create
        # follow_idがidのものを取得しようとして、なければ作成する。
        page_user = User.find(params[:relationship][:follow_id])
        following = current_user.relationships.find_or_initialize_by(follow_id: page_user.id)
        page_user.create_notification_follow!(current_user)
        unless current_user.relationships.exists?(follow_id: page_user.id)
            if following.save
                render json: {
                    following: following
                }, status: :ok
            else
                render json: { 
                    error: "Failed to destroy"
                }, status: 422
            end
        end
    end

    def destroy
        page_user = User.find(params[:id])
        following = current_user.relationships.find_by(follow_id: page_user.id)
        if current_user.relationships.exists?(follow_id: page_user.id)
            if following.destroy
                render json: {
                    following: following
                }, status: :ok
            else
                render json: { 
                    error: "Failed to destroy"
                }, status: 422
            end
        end
    end
    
end
