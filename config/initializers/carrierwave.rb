CarrierWave.configure do |config|
  config.storage = :grid_fs
  config.grid_fs_access_url = "/gfs"
  #config.root = Rails.root.join('tmp')
  #config.cache_dir = "uploads"
end

# CarrierWave.configure do |config|
#  config.grid_fs_database = Mongoid.database.name
#  config.grid_fs_host = Mongoid.config.master.connection.host
#  config.grid_fs_database = "rails_mongoid_#{Rails.env}"
#  config.grid_fs_host = Mongoid.database.connection.primary_pool.host
#  config.storage = :grid_fs
#  config.grid_fs_access_url = "/images"
# end