require 'sinatra'
require 'mongoid'
require 'mongoid-grid_fs'
require 'sinatra/namespace'

require './models/queue_item'

class RadioBaggaBackend < Sinatra::Base
  register Sinatra::Namespace

  # DB setup
  Mongoid.load! "mongoid.config"

  # API requests
  namespace '/v1' do
    get '/queue' do
      QueueItem.all.to_json
    end
  end
end
