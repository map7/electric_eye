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
      puts @configEye.config.cameras

      pids = []
      # Step through each camera
      @configEye.config.cameras.each do |camera|
        # Let's first record two 1minute videos of each camera.
        # This will turn into a never ending loop until we stop the process.
        pids << fork do
          stop_recording = false
          Signal.trap('INT') { stop_recording = true }
          until stop_recording
            info "Recording #{camera[:name]} to #{path(camera)}..."

            # Set a recording going using vlc, hold onto the process till it's finished.
            cmd="cvlc --qt-minimal-view --no-audio -R #{camera[:url]} --sout file/ts:#{path(camera)}"
            pid,stdin,stdout,stderr=Open4::popen4(cmd)

            sleep @configEye.config.duration
            `kill -9 #{pid}`        # Stop current recording.
          end
        end
      end

      store_pids(pids)
      info "Cameras recording"
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
      "#{dir}/#{Time.now.strftime('%Y%m%d-%H%M')}-#{camera[:name]}.mjpeg"
    end

    def initialize(configEye)
      @configEye = configEye
    end
  end
end
