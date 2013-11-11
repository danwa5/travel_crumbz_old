class Preference
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user, inverse_of: :preference

  field :display_tiles, type: Integer, default: 9
  field :sort_key, type: String, default: "start_date"
  field :sort_order, type: String, default: "DESC"

  validates_presence_of :display_tiles, :sort_key, :sort_order
end
