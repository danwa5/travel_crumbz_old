class Preference
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user, inverse_of: :preference

  field :num_tiles, type: Integer, default: 9
  field :sort_key, type: String, default: "start_date"
  field :sort_order, type: String, default: "DESC"

  validates_presence_of :num_tiles
end
