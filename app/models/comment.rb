class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include ApplicationHelper

  embedded_in :post, inverse_of: :comments

  validates_presence_of :rating, :body

  field :rating, type: Integer
  field :body, type: String

  def get_create_date
    String str = String.new
    unless self.created_at.blank?
      str << date_ordinal_format(self.created_at)
    end
  end
end
