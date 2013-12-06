class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ApplicationHelper

  belongs_to :user
  has_many :comments
  embeds_one :location
  embeds_many :photos
  accepts_nested_attributes_for :location, :allow_destroy => true #, reject_if: lambda { |a| a[:country].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :comments, :allow_destroy => true #, :dependent => :destroy , :autosave => true
  accepts_nested_attributes_for :photos, :allow_destroy => true

  validates_presence_of :title, :body
  validates_associated :location

  before_save { 
    self.title = post_title_case(self.title)
  }

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

  def get_dates(format)
    String str = String.new
    unless self.start_date.blank?
      unless self.end_date.blank?
        if format == 'ordinal'
          str << " to " + date_ordinal_format(self.end_date)
        else
          str << " to " + date_short_format(self.end_date)
        end
      end

      if format == 'ordinal'
        str.prepend(date_ordinal_format(self.start_date))
      else
        str.prepend(date_short_format(self.start_date))
      end
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

  def post_title_case(title)
    cap_exceptions = [ 
      'of','a','the','and','an','or','nor','but','if','then','else','when',
      'up','at','from','by','on', 'off','for','in','out','over','to'
    ]
    title = title.downcase.split.map {|w| cap_exceptions.include?(w) ? w : w.capitalize}.join(" ")
    title = title[0,1].capitalize + title[1, title.length-1]
  end

  def self.get_first_day_of_month(month, year)
    Time.new(year, month, 1)
  end

  def self.get_last_day_of_month(month, year)
    if (month == "12")
      Time.new(year, month, 31)
    else
      Time.new(year, (month.to_i + 1) , 1) - 1
    end
  end

  def cover_photo(tile_num)
    if self.photos.count > 0
      match = {"$match" => {"_id" => self.id}}
      project = { "$project" => {"photos" => 1}}
      unwind = { "$unwind" => "$photos"}
      match2 = {"$match" => {"photos.cover_photo" => true}}
      limit = {"$limit" => 1}
      results = Array.new
      results = collection.aggregate([match, project, unwind, match2, limit])

      med_arr = [3,6,7]
      if results.blank?
        if med_arr.include? (tile_num)
          self.photos.first.image_url(:medium)
        else
          self.photos.first.image_url
        end
      else
        id = results[0]["photos"]["_id"]

        if med_arr.include? (tile_num)
          self.photos.find(id).image_url(:medium)
        else
          self.photos.find(id).image_url
        end
      end
    else
      '/assets/trees.jpg'
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

  def self.all_posts(user)
    unless user.blank?
      where(:user_id => user.id).sort("start_date DESC")
    end
  end

  def self.posts_by_countries(user)
    unless user.blank?
      match = {"$match" => {"user_id" => user.id }}
      project = {"$project" => {"location.country" => 1}}
      group = {"$group" => {"_id" => {"country" => "$location.country"}, "posts_count" => {"$sum" => 1}}}
      sort = {"$sort" => {"_id.country" => 1}}
      collection.aggregate([match, project, group, sort])
    end
  end

  def self.posts_by_travel_dates(user)
    unless user.blank?
      match = {"$match" => {"user_id" => user.id, "start_date" => {"$ne" => nil}}}
      group = {"$group" => {"_id" => {"year" => {"$year" =>"$start_date"}, "month" => {"$month" => "$start_date"}}, "posts_count" => {"$sum" => 1}}}
      sort = {"$sort" => {"_id.year" => -1, "_id.month" => -1}}
      collection.aggregate([match, group, sort])
    end
  end

  def self.posts_by_travel_date(user, month, year)
    unless user.blank? || month.blank? || year.blank?
      # match1 = { "$match" => {"user_id" => user.id, "start_date" => {"$exists" => true}} }
      # project = { "$project" => {"user_id" => 1, "title" => 1, "body" => 1, "starred" => 1, "created_at" => 1, "updated_at" => 1, "start_date" => 1, "end_date" => 1, "location" => 1, "month" => {"$month" => "$start_date"}, "year" => {"$year" => "$start_date"}} }
      # match2 = { "$match" => {"month" => 5, "year" => 2013}}
      # sort = {"$sort" => {"start_date" => -1}}
      # Post.collection.aggregate([match1, project, match2])

      firstDay = get_first_day_of_month(month,year)
      lastDay = get_last_day_of_month(month,year)
      where(:user_id => user.id).and(:start_date => {"$gte" => firstDay}).and("start_date" => {"$lte" => lastDay}).sort("start_date DESC")
    end
  end

  def self.posts_by_country(user, country)
    unless user.blank?
      where(:user_id => user.id,"location.country" => country).sort("start_date DESC")
    end
  end

  def self.posts_with_photos(user)
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

      where(:user_id => user.id, :photos.exists => true, :photos.ne => []).sort(sortKey + " " + sortOrder).limit(limitCount)
    end
  end

  # def self.starred_posts(user)
  #   unless user.blank?
  #     if user.preference?
  #       sortKey = user.preference.sort_key
  #       sortOrder = user.preference.sort_order
  #       limitCount = user.preference.display_tiles
  #     else
  #       sortKey = "start_date"
  #       sortOrder = "DESC"
  #       limitCount = 9
  #     end

  #     where(:user_id => user.id, :starred => true).sort(sortKey + " " + sortOrder).limit(limitCount)
  #   end
  # end

  def self.location_search(user, query)
    where("user_id" => user.id).any_of({"location.city" => /#{query}/i}, {"location.country" => /#{query}/i}, {"location.street" => /#{query}/i})
  end

  def self.content_search(user, query)
    where("user_id" => user.id).any_of({"title" => /#{query}/i}, {"body" => /#{query}/i})
  end

end
