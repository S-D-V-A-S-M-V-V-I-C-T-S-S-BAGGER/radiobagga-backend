class RadioController
  def play_file(file_name)
    if file_name[-4, 4].equal? ".wav"
      _command = "sudo ./pifm %s %s 22050 stereo" % [file_name, ENV['FM_FREQUENCY']]
    else
      _command = "ffmpeg -i %s -f s16le -ar 22.05k -ac 1 - | sudo ./pifm - %s"
    end
    cmd(_command)
  end
end
