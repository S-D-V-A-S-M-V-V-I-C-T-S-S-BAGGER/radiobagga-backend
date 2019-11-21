require 'sinatra'
require 'sinatra/namespace'
require 'dotenv/load'

require_relative 'controllers/queue_controller'

# Main controller that handles API requests
class RadioBaggaBackend < Sinatra::Base
  register Sinatra::Namespace

  @queue = QueueController.new

  before do
    content_type :json
  end

  # GET request to `/v1/queue` will result in the current queue
  # Optionally takes 2 arguments: start and count
  #
  # == Parameters:
  # start::
  #   starting position in the queue, defaults to current position
  # count::
  #   amount of items to list from the starting position, defaults to 3 items
  #
  # == Returns:
  # Current queue as requested
  get '/v1/queue' do
    _start = params[:start]
    _count = params[:count]
    @queue.list_queue(_start, _count)
  end

  # POST request to `/v1/queue` for adding a song to the queue
  # Takes one argument: name
  #
  # == Parameters:
  # name::
  #   name of the song to be added
  post '/v1/queue' do
    _filename = params[:name]
    if _filename.nil? or not Pathname.exist? "uploads/#{_filename}"
      status 449
    else
      @queue.add _filename
    end
  end

  # POST request to `/v1/upload` for uploading a new file to be requested.
  # Returns error code 449 if no file is provided
  # Be sure to use encoding-type in the HTML form!
  #
  # == Parameters:
  # file::
  #   Uploaded file
  post '/v1/upload' do
    _tempfile = params[:file][:tempfile]
    _filename = params[:file][:filename]
    if _tempfile.nil? or _filename.nil?
      status 449
    else
      FileUtils.mv _tempfile.path, "uploads/#{_filename}"
    end
  end

  # GET request to `/v1/search` for searching in the available files
  # Takes one optional parameter: query
  # Defaults to all files if no query is provided
  #
  # == Parameters:
  # query::
  #   Search query
  #
  # == Returns:
  # List of queue items that match the query
  get '/v1/search' do
    _query = params[:query]
    if _query.nil?
      Dir['./uploads']
    else
      Dir["./uploads/**#{_query}**"]
    end
  end
end
