require 'methadone'
require 'open4'
require 'fileutils'

module ElectricEye
  class Record

    include Methadone::CLILogging
    
    def store_pids(pids = [])
      File.open(PID_FILE, "w") { |file| file.write pids.join(" ") }
    end

    def start
      @motion = Motion.new      # Create a new instance method to our motion library
      
      pids = []

      # Step through each camera
      @configEye.config.cameras.each do |camera|

        # Start the recording for each camera
        stop_recording = false
        Signal.trap('INT') { stop_recording = true }
        
        # until stop_recording
        path = "#{path(camera)}"
        debug "Recording #{camera[:name]} to #{path}.mjpeg..."
        
        # Set a recording going using vlc, hold onto the process till it's finished.
        # segment_time = how much time to record in each segment in seconds, ie: 3600 = 1hr
        # sgement_wrap = how many copies
        loglevel = "-loglevel panic" if logger.level >= 1
        cmd="ffmpeg -f mjpeg -i #{camera[:url]} #{loglevel} -acodec copy -vcodec copy -y -f segment -segment_time #{@configEye.config.duration} -segment_wrap #{@configEye.config.wrap}  #{path}%03d.mjpeg"

        # Run command and add to our pids to make it easy for electric_eye to clean up.
        pids << Process.spawn(cmd)

        # # Look for any motion
        # Thread.new(path) do |threadPath| 
        #   @motion.create_log(threadPath) # Create the motion detection log file.

        #   # Remove the log & recording if there is no motion
        #   if @motion.detect("#{threadPath}.log", @configEye.config.threshold)
        #     debug "KEEP #{threadPath}.mjpeg (motion)"
        #   else
        #     remove(threadPath)
        #   end
        # end
      end

      store_pids(pids)
      info "Cameras recording"
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
      "#{dir}/#{Time.now.strftime('%Y%m%d')}-#{camera[:name]}"
    end

    def initialize(configEye)
      @configEye = configEye
    end
  end
end
