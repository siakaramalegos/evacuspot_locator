require 'sinatra'
require 'sinatra/partial'
require 'sinatra/reloader' if development?
require 'erb'
require 'json'
require 'uri'
require 'pry' if development?
require 'httparty'
require 'envyable'

# Load secrets
Envyable.load('env.yml')

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
  erb :index
end

# List of closest EvacuSpots
get '/list' do
  erb :list
end

# Directions page
get '/directions' do
  erb :directions
end