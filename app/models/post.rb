class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ApplicationHelper

  embeds_many :comments
  embeds_one :location
  accepts_nested_attributes_for :location #, reject_if: lambda { |a| a[:country].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :comments

  validates_presence_of :title, :body
  validates_associated :location

  field :title, type: String
  field :body, type: String
  field :starred, type: Mongoid::Boolean
  field :start_date, type: Date
  field :end_date, type: Date
  field :likes, type: Integer
  field :loves, type: Integer

  index({ starred: 1 })

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

  # Data access methods

  def self.latest_posts
    all.sort("created_at DESC").limit(10)
  end

  def self.posts_by_countries
    project = {"$project" => {"location.country" => 1}}
    group = {"$group" => {"_id" => {"country" => "$location.country"}, "posts_count" => {"$sum" => 1}}}
    sort = {"$sort" => {"_id.country" => 1}}
    collection.aggregate([project, group, sort])
  end

  def self.posts_by_country(country)
    where("location.country" => country).sort("start_date DESC")
  end

  def self.starred_posts
    where(starred: true).sort("start_date DESC")
  end
end
