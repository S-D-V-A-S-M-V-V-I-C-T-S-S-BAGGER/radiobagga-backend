# Controller that executes the actual command for broadcasting a song
class RadioController
  # Play a file onto an FM frequency given in the `FM_FREQUENCY` environment variable
  #
  # == Parameters:
  # file_name::
  #   filename of the song to be played
  #
  # == Returns:
  # `boolean` value that represents successful execution of the `system` function call
  def play_file(file_name)
    _command = "sudo ./fm_transmitter -f %s ./uploads/%s" % [ENV['FM_FREQUENCY'], file_name]
    puts "Running: %s" % _command
    system(_command)
  end
end
