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

    def path(path)
      path
    end
  end
end
