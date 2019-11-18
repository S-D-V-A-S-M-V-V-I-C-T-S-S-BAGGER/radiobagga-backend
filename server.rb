require 'sinatra'
require 'sinatra/namespace'

require_relative 'controllers/queue_controller'

class RadioBaggaBackend < Sinatra::Base
  register Sinatra::Namespace

  @queue = QueueController.new

  before do
    content_type :json
  end

  # API requests
  namespace '/v1' do
    get '/queue' do
      _start = params[:start]
      _count = params[:count]
      @queue.list_queue(_start, _count)
    end

    post '/queue' do
      _filename = params[:name]
      if _filename.nil? or not Pathname.exist? "uploads/#{_filename}"
        status 449
      else
        @queue.add _filename
      end
    end

    post '/upload' do
      _tempfile = params[:file][:tempfile]
      _filename = params[:file][:filename]
      if _tempfile.nil? or _filename.nil?
        status 449
      elsif _filename[-3, 4].downcase != ".wav"
        status 422
      else
        FileUtils.mv _tempfile.path, "uploads/#{_filename}"
      end
    end

    get '/search' do
      _query = params[:query]
      if _query.nil?
        Dir['./uploads']
      else
        Dir["./uploads/**#{_query}**"]
      end
    end
  end
end
