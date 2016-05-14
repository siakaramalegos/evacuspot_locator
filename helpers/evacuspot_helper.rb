module EvacuspotHelper

  # Get geo-location using IP address of device
  # TODO: switch to use navigator.geolocation.getCurrentPosition as primary position-finder then IP address as back-up
  def set_device_location(ip_address)
    uri = "http://freegeoip.net/json/#{ip_address}"
    location_response = HTTParty.get(uri)
    latitude = location_response["latitude"]
    longitude = location_response["longitude"]
    session[:location] = {latitude: latitude, longitude: longitude}
  end

end