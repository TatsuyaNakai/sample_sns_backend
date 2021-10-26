class Post < ApplicationRecord
  mount_uploader :image, PostImageUploader

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy

  def create_notification_like!(current_user)
    # visitor_idは引数のuser, visited_idは主語のuser, post_idは主語のpostのid, actionはlikeのテーブルを全取得する。
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # 既に１件でもある場合はNoticeが作られてるはずなので、2回目以降の時は作成しないようにしてる。
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # # 自分自身がいいねしたときにcheckedをtrueにする。
      # if notification.visitor_id == notification.visited_id
      #   notification.checked = true
      # end
      # notification.save if notification.valid?
      # # ここまで

      # 自分自身がいいねしたときには、通知に保存すらしない。
      unless notification.visitor_id == notification.visited_id
        notification.save
      end
      # ここまで
    end
  end

  # 特定のpostのuser_idが自分のidではないレコード全てをuser_idだけをcommentテーブルから抽出して取得する。
  # その抽出されたテーブルのuser_idを使って通知を作成する。(save_notification_commentの内容)
  def create_notification_comment!(current_user, comment_id)
    user_ids_in_comment_record = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    user_ids_in_comment_record.each do |user_id_in_comment_record|
      save_notification_comment!(current_user, comment_id, user_id_in_comment_record['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if user_ids_in_comment_record.blank?
  end
  
  # 自分の投稿に自分がコメントした場合には、checkedをtrueにして、それ以外は普通にactionがcommentの通知を作成する。
  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # # 自分自身がコメントしたときはcheckedをtrueにしてる。
    # if notification.visitor_id == notification.visited_id
    #   notification.checked = true
    # end
    # notification.save if notification.valid?
    # # ここまで

    # 自分自身がコメントしたときには、通知に保存すらしない。
    unless notification.visitor_id == notification.visited_id
      notification.save
    end
    # ここまで
  end
end
