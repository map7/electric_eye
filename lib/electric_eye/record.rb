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
        # Let's first record two 1minute videos of each camera.
        # This will turn into a never ending loop until we stop the process.
        pids << fork do
          stop_recording = false
          Signal.trap('INT') { stop_recording = true }
          until stop_recording
            path = "#{path(camera)}"
            debug "Recording #{camera[:name]} to #{path}.mjpeg..."
            
            # Set a recording going using vlc, hold onto the process till it's finished.
            cmd="cvlc #{camera[:url]} --sout file/ts:#{path}.mjpeg"
            pid,stdin,stdout,stderr=Open4::popen4(cmd)

            # Wait for a defined duration from the config file.
            seconds = @configEye.config.duration
            while(seconds > 0)
              sleep 1
              seconds -= 1
              break if stop_recording
            end
            
            Process.kill 9, pid # Stop current recording.
            Process.wait pid    # Wait around so we don't get Zombies

            # Look for any motion
            fork do
              @motion.create_log(path) # Create the motion detection log file.

              # Remove the log & recording if there is no motion
              if @motion.detect("#{path}.log")
                debug "KEEP #{path}.mjpeg (motion)"
              else
                remove(path)
              end
            end
          end
        end
        
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
      "#{dir}/#{Time.now.strftime('%Y%m%d-%H%M')}-#{camera[:name]}"
    end

    def initialize(configEye)
      @configEye = configEye
    end
  end
end
