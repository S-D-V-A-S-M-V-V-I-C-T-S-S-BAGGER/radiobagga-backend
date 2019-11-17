require 'sinatra'
require 'sinatra/namespace'

require './models/queue_item'
require './controllers/radio_controller'

class RadioBaggaBackend < Sinatra::Base
  register Sinatra::Namespace

  QueueController.run!

  # API requests
  namespace '/v1' do
    get '/queue' do
      QueueController.list_queue
    end
  end
end
