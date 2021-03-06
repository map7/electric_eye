require 'methadone'
require 'open4'
require 'fileutils'
require 'filewatcher'

module ElectricEye
  class Record

    include Methadone::CLILogging

    def ffmpeg_bin
      # Allow overriding the location of the ffmpeg bin if you require.
      # We use special features of ffmpeg 3.0 so you might want to compile this in a separate directory
      # for instance /opt/ffmpeg_3.0 would be a nice location.
      ENV['FFMPEG_BIN'] || 'ffmpeg'
    end
    
    def store_pids(pids = [])
      File.open(PID_FILE, "w") { |file| file.write pids.join(" ") }
    end

    def start
      # @motion = Motion.new      # Create a new instance method to our motion library
      
      pids = []
      # Start the recording for each camera
      # Step through each camera
      @configEye.config.cameras.each do |camera|

        # until stop_recording
        path = "#{path(camera)}"
        listfile = "#{path}.list"
        debug "Recording #{camera[:name]} to #{path}.mpeg..."
        
        # Set a recording going using vlc, hold onto the process till it's finished.
        # segment_time = how much time to record in each segment in seconds, ie: 3600 = 1hr
        # sgement_wrap = how many copies
        loglevel = "-loglevel panic" if logger.level >= 1

        # ffmpeg 3.0.1 used
        cmd="#{ffmpeg_bin} -i #{camera[:url]} #{loglevel} -c copy -f segment -segment_list #{listfile} -segment_time #{@configEye.config.duration} -segment_wrap #{@configEye.config.wrap} -y -reconnect 1 -reconnect_at_eof 1 -reconnect_streamed 1 -reconnect_delay_max 300 #{path}%03d.mjpeg"

        # Run command and add to our pids to make it easy for electric_eye to clean up.
        info "Starting to record #{camera[:name]}"
        pids << Process.spawn(cmd)

        # Start the motion detection for this camera
        pids << fork {start_motion_detection(camera)} 
      end

      store_pids(pids)
      info "Cameras recording"
    end

    # Start motion detection
    def start_motion_detection(camera)
      # Watch the ffmpeg segment list output file which will trigger the block within
      # where we can look at the last line in the file and perform post motion detection.

      dir =dir(camera)
      path = path(camera)
      output = "#{dir}/#{date_filename(camera)}.mpeg"

      # Watch the directory & read from the list file
      filewatcher = FileWatcher.new("#{path}*.mjpeg")
      filewatcher.watch do |f|
        file = read_listfile("#{path}.list")
        if file and !File.exists?(output)
          debug "Processing #{file}"
          

          # Run motion detection on the file, make sure that we output to a different file.
          loglevel = "-loglevel panic" if logger.level >= 1

          if File.exists?("/opt/ffmpeg3/bin/ffmpeg")
            cmd="/opt/ffmpeg3/bin/ffmpeg -i #{dir}/#{file} #{loglevel} -y -vf \"select=gt(scene\\,0.003),setpts=N/(25*TB)\" #{output}"
          else
            cmd="#{ffmpeg_bin} -i #{dir}/#{file} #{loglevel} -y -vf \"select=gt(scene\\,0.003),setpts=N/(25*TB)\" #{output}"
          end
          
          # Run command and add to our pids to make it easy for electric_eye to clean up.
          Process.spawn(cmd)
        end
      end
    end

    # Read the last line from the list file.
    def read_listfile(listfile)
      lines = File.open(listfile).readlines
      lines.last.chomp! unless lines.length == 0
    end

    def stop
      stop_recordings(get_pids) if File.exist?(PID_FILE)
    end

    def stop_recordings(pids)
      info "Stop recordings with PID: #{pids}..."
      Open4::popen4("kill -INT #{pids}") # Kill all recordings
      File.delete(PID_FILE)   # Remove the pid file.
    end

    def get_pids
      File.open(PID_FILE, "r").gets # Get pids
    end
    
    def dir(camera)
      dir = "#{@configEye.config.path}/#{camera[:name]}"
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      dir
    end

    def date_filename(camera)
      "#{Time.now.strftime('%Y%m%d-%H%M%S')}-#{camera[:name]}"
    end

    def path(camera)
      "#{dir(camera)}/#{camera[:name]}"
    end

    def initialize(configEye)
      @configEye = configEye
    end
  end
end
