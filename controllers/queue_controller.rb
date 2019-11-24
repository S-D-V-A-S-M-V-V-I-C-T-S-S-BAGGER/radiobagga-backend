require_relative 'radio_controller'

# Controller that handles operations on the queue and decides what song to play
class QueueController

  # Initialize the queue controller with some basic variables, then start playing songs from the queue
  def initialize
    super()
    @queue = [ENV['BAGGA_DEFAULT_SONG']]
    @queue_index = 0
    @radio = RadioController.new
    @is_running = false
    start_queue
  end

  # Main run method of the queue controller
  # Infinitely loops and plays either the current song in the queue, or the default song
  def run
    loop do
      if @queue[@queue_index]
        puts 'Playing queued song!'
        @radio.play_file @queue[@queue_index]
        @queue_index += 1
      else
        puts 'Falling back to default song'
        @radio.play_file ENV['BAGGA_DEFAULT_SONG']
      end
    end
  end

  # Wrapper method for starting the queue
  # Checks if a queue is already running to prevent duplicate threads
  def start_queue
    @queue_runner = Thread.new run unless @is_running
    @is_running = true
  end

  # Wrapper method for stopping the queue
  # Checks if the queue was actually running in the first place
  def stop_queue
    @queue_runner.terminate if @is_running
    @is_running = false
  end

  # Get the current state of the queue
  #
  # == Parameters:
  # _start::
  #   Index where to start the queue, defaulting to the current index
  # _count::
  #   Amount of queue items to fetch, defaulting to 3
  #
  # == Returns:
  # List of queue items
  def list_queue(_start, _count)
    @queue[_start.to_i, _count.to_i]
  end

  # Get the current item being played
  #
  # == Returns:
  # Queue item
  def get_current
    _current = @queue[@queue_index]
    if _current.nil?
      ENV['BAGGA_DEFAULT_SONG']
    end
    _current
  end

  # Get the current index in the queue
  #
  # == Returns:
  # Queue index
  def get_index
    @queue_index
  end

  # Add a new song to the queue
  #
  # == Parameters:
  # filename::
  #   A `string` that has to be an existing file in the `./output` folder
  # == Returns:
  # `boolean` value representing success
  def add(filename)
    @queue.append filename
  end

  # Enable or disables the queue
  #
  # == Parameters:
  # enable::
  #   A `boolean` value whether to start or stop the queue
  def set_state(enable)
    if enable
      start_queue
    else
      stop_queue
    end
  end
end
