class Api::V1::NotificationsController < ApplicationController

    def index
        # テスト用、falseにしない。
        # notifications = current_user.passive_notifications;
        # 確認してないものだけを渡してあげたい時は以下に変更する。
        notifications = current_user.passive_notifications.where(checked: false);

        # 上記の配列にアクションを起こしたUserのnameを加える。
        notifications_with_username = notifications.map{ |notification|
            # フォローの時には、titleが存在しない。その時はエラーになるので分岐させてる。
            if notification.post.present?
                notification.attributes.merge(name: notification.visitor.name, avatar: notification.visitor.image, title: notification.post.title );
            else
                notification.attributes.merge(name: notification.visitor.name, avatar: notification.visitor.image );
            end
        }
        render json: {
            notifications: notifications_with_username
        }, status: :ok
        notifications.where(checked: false).each do |notification|
            notification.update!(checked: true)
        end
    end

    # indexのcheckedをfalseのままにするメソッド
    def observe
        # テスト用
        # notifications = current_user.passive_notifications;
        # visited_idが主語のuser_idになっている、かつ checkedがfalseになってるNotificationを全て取得してる。
        notifications = current_user.passive_notifications.where(checked: false);
        
        # # 上記の配列にアクションを起こしたUserのnameを加える。
        notifications_with_username = notifications.map{ |notification|
            # フォローの時には、titleが存在しない。その時はエラーになるので分岐させてる。
            if notification.post.present?
                notification.attributes.merge(name: notification.visitor.name, avatar: notification.visitor.image, title: notification.post.title );
            else
                notification.attributes.merge(name: notification.visitor.name, avatar: notification.visitor.image );
            end
        }
        render json: {
            notifications: notifications_with_username
        }, status: :ok
    end

end
