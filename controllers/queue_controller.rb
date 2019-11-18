require_relative 'radio_controller'

class QueueController
  @queue = []
  @queue_index = -1

  @radio = RadioController.new

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

  def list_queue(_start = @queue_index, _count = 3)
    @queue[_start, _count]
  end

  def get_current
    @queue[@queue_index]
  end

  def add(filename)

    @queue.append filename
  end
end
