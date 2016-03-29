require 'methadone'
require 'open4'
require 'fileutils'
require 'filewatcher'

module ElectricEye
  class Record

    include Methadone::CLILogging
    
    def store_pids(pids = [])
      File.open(PID_FILE, "w") { |file| file.write pids.join(" ") }
    end

    def start
      @motion = Motion.new      # Create a new instance method to our motion library
      
      pids = []

      # Start the recording for each camera
      stop_recording = false

      # Signal.trap('INT') do
      #   stop_recording = true
      #   Process.kill 9, ffmpeg_pid
      #   Process.wait ffmpeg_pid
      # end
      
      # Step through each camera
      @configEye.config.cameras.each do |camera|
        
        # until stop_recording
        path = "#{path(camera)}"
        listfile = "#{path}.list"
        debug "Recording #{camera[:name]} to #{path}.mjpeg..."
        
        # Set a recording going using vlc, hold onto the process till it's finished.
        # segment_time = how much time to record in each segment in seconds, ie: 3600 = 1hr
        # sgement_wrap = how many copies
        loglevel = "-loglevel panic" if logger.level >= 1
        cmd="ffmpeg -f mjpeg -i #{camera[:url]} #{loglevel} -acodec copy -vcodec copy -y -f segment -segment_list #{listfile} -segment_time #{@configEye.config.duration} -segment_wrap #{@configEye.config.wrap}  #{path}%03d.mjpeg"

        # Run command and add to our pids to make it easy for electric_eye to clean up.
        info "Starting to record #{camera[:name]}"
        pids << Process.spawn(cmd)

        # # Start the motion detection for this camera
        # puts "before thread"
        # Thread.new(listfile) do |listfile|
        #   `echo "listfile: #{listfile}" >> #{listfile}.log`
        #   start_motion_detection(listfile)
        # end
      end

      store_pids(pids)
      info "Cameras recording"
    end

    # Start motion detection
    def start_motion_detection(listfile)
      if File.exists?(listfile)
        # Watch the ffmpeg segment list output file which will trigger the block within
        # where we can look at the last line in the file and perform post motion detection.
        FileWatcher.new(listfile).watch do |listfile|
          `echo "listfile2: #{listfile}" >> #{listfile}.log`
          # Get last line
          file = read_listfile(listfile)

          `echo "file: #{file}" >> #{listfile}.log`
          # Run post motion detection
          if file
            cmd="ffmpeg -i #{file} -vf \"select=gt(scene\,0.003),setpts=N/(25*TB)\" #{file}-motion.mjpeg"
            `echo "cmd: #{cmd}" >> #{listfile}.log`
            # Run command and add to our pids to make it easy for electric_eye to clean up.
            # Process.spawn(cmd)
          end
        end
      end
    end

    def read_listfile(listfile)
      lines = File.open(listfile).readlines
      lines.last.chomp! unless lines.length == 0
    end

    # Remove a recording
    def remove(path)
      debug "REMOVE #{path}.mjpeg (no motion)"
      File.delete("#{path}.log")
      File.delete("#{path}.mjpeg")
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
    
    def path(camera)
      dir = "#{@configEye.config.path}/#{camera[:name]}"
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      "#{dir}/#{camera[:name]}"
    end

    def initialize(configEye)
      @configEye = configEye
    end
  end
end
