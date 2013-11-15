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

end