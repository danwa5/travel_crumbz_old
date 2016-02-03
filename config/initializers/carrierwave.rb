CarrierWave.configure do |config|

  config.root = Rails.root.join('tmp')
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  if Rails.env.production?
    config.storage = :fog
    
    config.fog_directory    = ENV['AWS_BUCKET_NAME']
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  else
    config.storage = :file
  end

  # config.storage = :fog
  # config.root = "#{Rails.root}/tmp"
  # config.cache_dir = "#{Rails.root}/tmp/uploads"
  # config.fog_directory    = ENV['S3_BUCKET_NAME']

  # config.fog_credentials = {
  #   :provider              => 'AWS',
  #   :aws_access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
  #   :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  # }
end

# if Rails.env.test? || Rails.env.development?
#     config.storage = :file
#     config.enable_processing = false
#     config.root = "#{Rails.root}/tmp"
#   else
#     config.storage = :fog
#   end
 
#   config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku
#   config.fog_directory    = ENV['S3_BUCKET_NAME']
#   config.s3_access_policy = :public_read                          # Generate http:// urls. Defaults to :authenticated_read (https://)
#   config.fog_host         = "#{ENV['S3_ASSET_URL']}/#{ENV['S3_BUCKET_NAME']}"
# end


# Configuration for avatar storage in GridFS moved to AvatarUploader
# CarrierWave.configure do |config|
#   config.storage = :grid_fs
#   config.grid_fs_access_url = "/gfs"
#   config.root = Rails.root.join('tmp')
#   config.cache_dir = "uploads"
# end