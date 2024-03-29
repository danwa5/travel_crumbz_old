class Photo
  include Mongoid::Document

  embedded_in :post, inverse_of: :photo

  mount_uploader :image, PhotoUploader

  # validates_presence_of :image
  
  field :image, type: String
  field :caption, type: String
  field :cover_photo, type: Mongoid::Boolean, default: false

  def image_name
    File.basename(photo.path || photo.filename) if photo
  end
end
