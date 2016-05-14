Spot = Struct.new(:type, :name, :address, :latitude, :longitude)

class Evacuspot
  attr_reader :list

  def initialize
    raw_evacuspots = retrieve_evacuspots
    @list = parse_evacuspots(raw_evacuspots)
  end

  private

  def parse_evacuspots(raw_evacuspots)
    evacuspots = []

    raw_evacuspots.each do |spot|
      type = spot["type"]
      name = spot["name"]
      address = spot["address"]
      latitude = spot["location"]["coordinates"][1]
      longitude = spot["location"]["coordinates"][0]

      evacuspots << Spot.new(type, name, address, latitude, longitude)
    end

    evacuspots
  end

  def retrieve_evacuspots
    uri = "https://data.nola.gov/resource/wue5-xy2g.json"
    HTTParty.get(uri)
  end
end
