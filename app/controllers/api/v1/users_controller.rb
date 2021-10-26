class Api::V1::UsersController < ApplicationController

  def show
    user = User.find(params[:id]);
    # フォローした人
    followings = user.followings
    # フォローしてくれた人
    followers = user.followers
    # お気に入りした投稿
    favorite_posts_with_username = user.likes.map{ |r|
      r.attributes.merge(title: r.post.title, content: r.post.content, image: r.post.image)
    }
    render json: {
      user: user,
      followings: followings,
      followers: followers,
      favoritePosts: favorite_posts_with_username
    }, status: :ok
  end
end
