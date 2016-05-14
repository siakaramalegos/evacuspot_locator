require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'uri'
require 'pry' if development?
require 'httparty'
require 'envyable'

# Load other Ruby files needed for app
require_relative 'helpers/evacuspot_helper'

# Load secrets
Envyable.load('env.yml')

# Helpers
helpers EvacuspotHelper

# Options for partials
set :partial_template_engine, :erb
enable :partial_underscores

# Saves search info
enable :sessions




# ****************************
#     Routes and controls
# ****************************

# Home page
get '/' do
  # Hard-code IP when in development
  Sinatra::Base.development? ? ip_address = '174.70.110.150' : ip_address = request.ip
  set_device_location(ip_address)

  if session[:location]
    latitude = session[:location][:latitude]
    longitude = session[:location][:longitude]
  else
    # Official New Orleans city center per Google Maps search
    latitude = 30.0204649
    longitude = -90.1636923
  end

  erb :index, locals: { latitude: latitude, longitude: longitude }
end

# List of closest EvacuSpots
get '/list' do
  erb :list
end

# Directions page
get '/directions' do
  erb :directions
end