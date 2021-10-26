10.times do |n|
    user = User.new(
        name: "sampleUser_#{n}",
        email: "sample00#{n}@gmail.com",
        password: "password_#{n}",
        password_confirmation: "password_#{n}",
        image: File.open("./public/default.jpg"),
        greet: "ぼくは、sampleUser_#{n}です。大量生成されたうちの1つになります。
        ぜひ仲良くしてください。よかったらフォローもしてください。
        よろしくお願いします。"
    )
    5.times do |m|
        user.posts.build(
            title: "title#1_#{m}",
            content: "content#1_#{m}",
            image: File.open("./public/dog.jpeg")
        )
    end
    5.times do |m|
        user.posts.build(
            title: "title#2_#{m}",
            content: "content#2_#{m}",
            image: File.open("./public/sample.jpeg")
        )
    end

    user.save!
end

10.times do |n|
    5.times do |m|
        user = User.find_by(id: n+1)
        user.likes.create!(
            user_id: n+1,
            post_id: m+1,
        )
    end

    5.times do |m|
        user = User.find_by(id: n+1)
        user.comments.create!(
            content: "comment#{m}",
            user_id: n+1,
            post_id: m+1,
        )
    end
    
    5.times do |m|
        user = User.find_by(id: n+1)
        user.relationships.create!(
            user_id: n+1,
            follow_id: m+1,
        )
    end
    
end
