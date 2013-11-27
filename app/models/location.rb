class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  #include Gmaps4rails::ActsAsGmappable

  embedded_in :post, inverse_of: :location

  geocoded_by :address
  after_validation :geocode #, :if => :location_changed?
  acts_as_gmappable :position => :to_coordinates, :process_geocoding => false

  validates_presence_of :city, :country

  before_validation { 
    self.city = self.city.titleize
    self.state = self.state.titleize
  }

  field :street, type: String
  field :city, type: String
  field :state, type: String
  field :country, type: String
  field :postal, type: String
  field :coordinates, type: Array

  #private

    def address
      str = String.new
      if !self.city.blank? && !self.country.blank?
        if !self.street.blank?
          str << self.street + ", "
        end
        str << self.city + ", " + self.country
      end
    end

    def city_country
      self.city + ", " + self.country
    end

    def to_coordinates
      unless self.coordinates.blank?
        [self.coordinates[1],self.coordinates[0]]
      end
    end
end
