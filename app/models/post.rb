class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  embeds_many :comments
  embeds_one :location
  accepts_nested_attributes_for :location #, reject_if: lambda { |a| a[:country].blank? }, :allow_destroy => true

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
      str << date_ordinal_format(self.start_date)
      if !self.end_date.blank?
        str << " to " + date_ordinal_format(self.end_date)
      end
    end
  end

  def get_start_date
    String str = String.new
    unless self.start_date.blank?
      str << date_ordinal_format(self.start_date)
    end
  end

  def date_ordinal_format(date)
    unless date.blank?
      #date.strftime("%B %-d, %Y")
      date.to_formatted_s(:long_ordinal)
    end
  end

  def snippet(str)
    unless str.blank?
      str = str.slice(0,100) + "...";
    end
  end

end
