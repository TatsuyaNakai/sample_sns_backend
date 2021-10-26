# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :image, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  has_many :active_notifications, class_name: 'Notification', foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: :visited_id, dependent: :destroy

  def create_notification_follow!(current_user)
    # visitor_idは引数のuser, visited_idは主語のid, actionはfollowで通知を取得する。
    follow_record = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if follow_record.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
  
end
