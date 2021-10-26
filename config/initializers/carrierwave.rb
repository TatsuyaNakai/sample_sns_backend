if Rails.env.development?
  CarrierWave.configure do |config|
      # バックエンド側のドメイン名を記入する。
      config.asset_host = "http://localhost:3000"
      config.storage = :file
      config.cache_storage = :file
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIA2WWUPXGBCVDTNLF4',
      aws_secret_access_key: "AKIA2WWUPXGBCVDTNLF4",
      region: "ap-northeast-1",
    }
    config.fog_directory = 'sns-portfolio'
    config.cache_storage = :fog
  end
end