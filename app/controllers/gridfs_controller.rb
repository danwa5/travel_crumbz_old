class GridfsController < ApplicationController

  def serve
    user_id = params[:user_id]
    begin
      user = User.find(user_id)

      if user.nil? || user.avatar.nil?
        raise Exception.new("Unable to find user with id #{user_id}")
      end

      filename = Pathname.new(env['PATH_INFO']).basename.to_s
      version = filename.include?('_') ? filename.split('_')[0] : nil

      gridfs_file = user.avatar.file_version(version)
      gridfs_file = user.avatar.file if gridfs_file.nil? || gridfs_file.length.nil?

      self.headers['Content-Length'] = gridfs_file.content_length.to_s
      self.headers['Expires'] = 1.year.from_now.httpdate
      self.response_body = gridfs_file.read
      self.content_type = gridfs_file.content_type
    rescue Exception => e
      self.status = :file_not_found
      self.content_type = 'text/plain'
      self.response_body = e.message
    end
  end

  # def serve
  #   content = @user.avatar.read
  #   if stale?(etag: content, last_modified: @user.updated_at.utc, public: true)
  #    send_data content, type: @user.avatar.file.content_type, disposition: "inline"
  #    expires_in 0, public: true
  #   end
  # end

  # def serve
  #   gridfs_path = env["PATH_INFO"].gsub("/images/", "")
  #   begin
  #     gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
  #     self.response_body = gridfs_file.read
  #     self.content_type = gridfs_file.content_type
  #   rescue
  #     self.status = :file_not_found
  #     self.content_type = 'text/plain'
  #     self.response_body = ''
  #   end
  # end

  # def serve
  #   gridfs_path = env["PATH_INFO"].gsub("/gfs/", "")
  #   begin
  #     gridfs_file = Mongoid::GridFS[gridfs_path]
  #     self.response_body = gridfs_file.data
  #     self.content_type = gridfs_file.content_type
  #   rescue
  #     self.status = :file_not_found
  #     self.content_type = 'text/plain'
  #     self.response_body = ''
  #   end
  # end

end