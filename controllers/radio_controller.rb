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
    # pi_fm_rds [-freq freq] [-audio file] [-ppm ppm_error] [-pi pi_code] [-ps ps_text] [-rt rt_text]
    _command = "sox -t %s \"./uploads/%s\" -t wav - | sudo ./pi_fm_rds -freq %s -pi 6969 -ps BAGGAFM -rt \"%s\" -audio -" % [file_name[-3..-1], file_name, ENV['FM_FREQUENCY'], file_name]
    puts "Running: %s" % _command
    system _command
    puts 'finished broadcast'
  end
end
