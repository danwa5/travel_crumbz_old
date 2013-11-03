module PostsHelper

  def configure_posts_for_gmaps(posts)
    @pins = String.new

    posts.each do |p|
      @pins = @pins + p.location.to_gmaps4rails.to_s
    end

    @pins = @pins.gsub(/\]\[/, ",")
    @pins = @pins.gsub(/"/,"'")
  end
  
end
