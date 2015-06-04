require 'methadone'
require 'table_print'

module ElectricEye
  class ConfigEye

    include Methadone::CLILogging
    
    # Check the directory and if it doesn't exist create it.
    def self.check_dir
      Dir.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
    end

    # Check that the config file exists.
    def self.load
      # Check if we have a config CONFIG_FILE
      ConfigEye.check_dir
      puts "ENVYEAH: #{ENV['HOME']}, #{CONFIG_DIR}, #{CONFIG_FILE}"
      if File.exist?(CONFIG_FILE)
        Construct.load File.read(CONFIG_FILE)
      else
        Construct.new({duration: 600, path: '~/recordings', cameras: []})
      end
    end

    # Save the config file
    def save()
      File.open(CONFIG_FILE, 'w'){ |f| f.write config.to_yaml } # Store
    end

    # Add camera
    def add_camera(camera, url)
      @config.cameras.push({name: camera, url: url})
      save
      info "Camera added"
    end

    # Remove camera
    def remove_camera(camera)
      record = @config.cameras.bsearch{ |c| c[:name] == camera }
      if record
        @config.cameras.delete(record)
        save
      end
      info "Camera removed"
    end

    # List cameras in setup
    def list_cameras
      info "Cameras"
      tp @config.cameras, :name, :url => {width: 120}
    end

    # Set duration
    def set_duration(seconds)
      @config.duration = seconds.to_i
      save
      info "Duration set to #{seconds} seconds"
    end

    # Set path
    def set_path(dir)
      @config.path = dir
      save
      info "Path set to #{dir}"
    end

    # Initialise the method.
    attr_reader :config
    def initialize
      @config = ConfigEye.load 
    end
  end
end
