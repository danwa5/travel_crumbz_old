class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :requester, class_name: "User", inverse_of: :friendships
  belongs_to :acceptor, class_name: "User", inverse_of: :inverse_friendships

  field :requester, type: BSON::ObjectId
  field :acceptor, type: BSON::ObjectId
  field :confirmed, :type => Mongoid::Boolean, :default => false
end
