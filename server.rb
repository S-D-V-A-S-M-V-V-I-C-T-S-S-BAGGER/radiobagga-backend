require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

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
