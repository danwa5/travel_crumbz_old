class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ApplicationHelper
  #include ActionView::Helpers

  belongs_to :user
  has_many :comments
  embeds_one :location
  accepts_nested_attributes_for :location #, reject_if: lambda { |a| a[:country].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :comments #, :dependent => :destroy , :autosave => true

  validates_presence_of :title, :body
  validates_associated :location

  field :title, type: String
  field :body, type: String
  field :starred, type: Mongoid::Boolean
  field :start_date, type: Date
  field :end_date, type: Date
  field :likes, type: Integer
  field :loves, type: Integer
  field :user_id, type: BSON::ObjectId

  index({ starred: 1 })
  index({ remember_token: 1 })
  index({ user_id: 1 })

  def get_dates
    String str = String.new
    unless self.start_date.blank?
      unless self.end_date.blank?
        str << " to " + date_ordinal_format(self.end_date)
      end
      str.prepend(date_ordinal_format(self.start_date))
    end
  end

  def get_start_date
    String str = String.new
    unless self.start_date.blank?
      str << date_ordinal_format(self.start_date)
    end
  end

  def snippet(str)
    unless str.blank?
      str = str.slice(0,100) + "...";
    end
  end

  def snippet_by_words(str, num_words)
    unless str.blank? || num_words.blank?
      String s = str.split[0...num_words].join(' ')
      #if !s.end_with?("...")
      #  s = s.concat("...")
      #end
    end
  end

  #########################
  #  Data access methods  #
  #########################

  def self.latest_posts(user)
    unless user.blank?
      where(:user_id => user.id).sort("created_at DESC").limit(10)
    end
  end

  def self.posts_by_countries(user)
    unless user.blank?
      match = {"$match" => {"user_id" => user.id}}
      project = {"$project" => {"location.country" => 1}}
      group = {"$group" => {"_id" => {"country" => "$location.country"}, "posts_count" => {"$sum" => 1}}}
      sort = {"$sort" => {"_id.country" => 1}}
      collection.aggregate([match, project, group, sort])
    end
  end

  def self.posts_by_travel_date(user)
    unless user.blank?
      match = {"$match" => {"user_id" => user.id}}
      group = {"$group" => {"_id" => {"year" => {"$year" =>"$start_date"}, "month" => {"$month" => "$start_date"}}, "posts_count" => {"$sum" => 1}}}
      sort = {"$sort" => {"_id.year" => -1, "_id.month" => -1}}
      collection.aggregate([match, group, sort])
    end
  end

  def self.posts_by_country(user, country)
    unless user.blank?
      where(:user_id => user.id,"location.country" => country).sort("start_date DESC")
    end
  end

  def self.starred_posts(user)
    unless user.blank?
      if user.preference?
        sortKey = user.preference.sort_key
        sortOrder = user.preference.sort_order
        limitCount = user.preference.display_tiles
      else
        sortKey = "start_date"
        sortOrder = "DESC"
        limitCount = 9
      end

      #where(:user_id.exists => true)
      where(:user_id => user.id, :starred => true).sort(sortKey + " " + sortOrder).limit(limitCount)
    end
  end

end
