class Api::V1::UsersController < ApplicationController

  def show
    user = User.find(params[:id])
    user_posts = user.posts.order(created_at: :desc)
    # フォローした人
    followings = user.followings
    # フォローしてくれた人
    followers = user.followers
    # お気に入りした投稿
    favorite_posts_with_username = user.likes.map{ |r|
      r.attributes.merge(title: r.post.title, content: r.post.content, image: r.post.image)
    }
    favorite_posts = favorite_posts_with_username.reverse
    
    render json: {
      user: user,
      userPost: user_posts,
      favoritePosts: favorite_posts,
      followings: followings,
      followers: followers,
    }, status: :ok
  end
end
