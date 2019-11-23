require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/cross_origin'
require 'dotenv/load'
require 'pathname'
require 'fileutils'
require 'json'

require_relative 'controllers/queue_controller'

# Main controller that handles API requests
class RadioBaggaBackend < Sinatra::Base
  register Sinatra::Namespace

  def initialize
    super()
    @queue = QueueController.new
  end

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    content_type :json
  end

  # GET request to `/v1/queue` will result in the current queue
  # Optionally takes 2 arguments: start and count
  #
  # == Parameters:
  # start::
  #   starting position in the queue, defaults to 0
  # count::
  #   amount of items to list from the starting position, defaults to 3 items
  #
  # == Returns:
  # Current queue as requested
  get '/v1/queue' do
    _start = params[:start] ? params[:start] : 0
    _count = params[:count] ? params[:count] : 3
    {:queue => @queue.list_queue(_start, _count)}.to_json
  end

  # POST request to `/v1/queue` for adding a song to the queue
  # Takes one argument: name
  #
  # == Parameters:
  # name::
  #   name of the song to be added
  post '/v1/queue' do
    _filename = params[:name]
    if _filename.nil? or not Pathname.new("./uploads/#{_filename}").exist?
      status 449
    else
      @queue.add _filename
      status 200
    end
  end

  # POST request to `/v1/upload` for uploading a new file to be requested.
  # Returns error code 422 if file is not of .WAV format
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
    elsif _filename[-4, 4].downcase != ".wav"
      status 422
    else
      FileUtils.mv _tempfile.path, "uploads/#{_filename}"
      status 200
      {:filename => _filename}.to_json
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
      {:results => Dir['./uploads/*'].map! {|item| item[10..-1]}}.to_json
    else
      {:results => Dir["./uploads/**#{_query}**"].map! {|item| item[10..-1]}}.to_json
    end
  end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
end
