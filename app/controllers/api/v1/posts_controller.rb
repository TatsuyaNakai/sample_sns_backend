class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]

  def index
    # 以下を実行するとURLのオブジェクトが壊れるのでできない。
    # pluckも同様にURLが壊れてしまうので、不可
    # posts_with_username = posts.map{ |r|
    #   r.attributes.merge(name: r.user.name)
    # }
    # なので、別で配列を渡すことにしてる。

    # 全ユーザーの投稿を出力
    posts = Post.order(updated_at: :desc)
    posts_username = posts.joins(:user).pluck(:name)
    # フォローしてる人たちの投稿と、名前を抽出する。
    following_posts = Post.where(user_id: [current_user.id, *current_user.following_ids])
    followings_posts_username = following_posts.joins(:user).pluck(:name)
    render json: {
      posts: posts,
      posts_userName: posts_username,
      following_posts: following_posts,
      following_posts_username: followings_posts_username,
    }, status: :ok
  end

  def show
    # 単体のモデルの場合はテーブルの時のようにjoinsが使用できなかったので、別で設定した。
    post = Post.find(params[:id])
    # 少し冗長な気がする。
    post_user = post.user
    # 特定のpostが持ってる（post_idがそれ）全てのcommentを格納
    comments = post.comments
    comments_with_columns = comments.map{ |r|
      r.attributes.merge(name: r.user.name, avatar: r.user.image)
    }
    render json: {
      post: post,
      post_user: post_user,
      comments: comments_with_columns
    }, status: :ok
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.save
      render json: {
        post: post
      }, status: :ok
    else
      render json: post.errors, status: 422
    end
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: {
        post: post
      }
    else
      render json: post.errors, status: 422
    end
  end

  def destroy
    if Post.destroy(params[:id])
      head :no_content
    else
      render json: { 
        error: "Failed to destroy"
      }, status: 422
    end
  end
  
  private
  def post_params
    params.permit(:title, :content, :image)
  end

end
