class RadioController
  def play_file(file_name)
    _command = "sudo ./fm_transmitter -f %s %s" % [ENV['FM_FREQUENCY'], file_name]
    puts "Running: %s" % _command
    system(_command)
  end
end
