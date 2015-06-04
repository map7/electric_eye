require 'methadone'

module ElectricEye
  class Record

    include Methadone::CLILogging
    
    def store_pids(pids = [])
      File.open("/tmp/electric_eye.pid", "w") { |file| file.write pids.join(" ") }
    end

    def start
      info "Cameras recording"
    end

    def path(path, camera)
      dir = "#{path}/#{camera[:name]}"
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      "#{dir}/#{Time.now.strftime('%Y%m%d-%H%M')}-#{camera[:name]}.mjpeg"
    end
  end
end
