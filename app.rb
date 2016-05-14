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
require_relative 'evacuspot_model'

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

# TODO: get session to work
post '/set_origin' do
  # TODO: Add validations
  # TODO: Use address entered
  # TODO: Refactor to use original location or address
  session[:travel_mode] = params[:travel_mode]
  session[:origin] = params[:user_address]

  redirect to ('/list')
end

# List of closest EvacuSpots
get '/list' do
  if session[:location]
    origin_lat = session[:location][:latitude]
    origin_lng = session[:location][:longitude]
    travel_mode = params[:travel_mode]

    evacuspots_structs = Evacuspot.new.list

    # Create a json version of the spots
    # TODO: refactor to only use this in view
    evacuspots = evacuspots_structs.map do |s|
      {type: s.type, name: s.name, address: s.address, latitude: s.latitude, longitude: s.longitude}
    end
    evacuspots_json = evacuspots.to_json
    session[:evacuspots] = evacuspots

    erb :list, locals: { origin_lat: origin_lat, origin_lng: origin_lng, evacuspots: evacuspots, travel_mode: travel_mode, evacuspots_json: evacuspots_json}
  else
    # Return home if no location set
    # TODO: add alert notice
    redirect to ('/')
  end
end

# Directions page
get '/directions' do
  origin_lat = session[:location][:latitude]
  origin_lng = session[:location][:longitude]
  spot = session[:evacuspots][params[:spot].to_i]
  erb :directions, locals: {spot: spot, latitude: origin_lat, longitude: origin_lng}
end