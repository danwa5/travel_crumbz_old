# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  CarrierWave.configure do |config|
    config.storage = :grid_fs
    config.grid_fs_access_url = "/gfs"
    config.root = Rails.root.join('tmp')
    config.cache_dir = "uploads"
  end

  # Choose what kind of storage to use for this uploader:
  # storage :file # => to store on filesystem
  storage :grid_fs

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_limit => [90, 90]
  
  #def scale(width, height)
  #end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_limit => [90, 90]
  # end

  def file_version(version = nil)    
    if version.nil?
      self.file
    elsif self.respond_to?(version)
      self.send(version).file 
    else
      nil
    end
  end

  def image?(file = nil)
    file = self.file if file.nil?

    return nil if file.nil?

    file.content_type.include?('image') 
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
