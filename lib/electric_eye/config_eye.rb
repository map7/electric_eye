require 'methadone'
require 'fileutils'
require 'table_print'

module ElectricEye
  class ConfigEye

    include Methadone::CLILogging
    
    # Check the directory and if it doesn't exist create it.
    def self.check_dir
      FileUtils.mkdir_p(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
    end

    # Check that the config file exists.
    def self.load
      # Check if we have a config CONFIG_FILE
      ConfigEye.check_dir
      if File.exist?(CONFIG_FILE)
        Construct.load File.read(CONFIG_FILE)
      else
        # Create a new file with defaults
        Construct.new({duration: 600, wrap: 168, path: '~/recordings', threshold: 2, cameras: []})
      end
    end

    # Save the config file
    def save()
      File.open(CONFIG_FILE, 'w'){ |f| f.write config.to_yaml } # Store
    end

    # Add camera
    def add_camera(camera, url)
      if camera.nil?
        warn "NO camera given"
      elsif url.nil?
        warn "NO url given"        
      else
        @config.cameras.push({name: camera, url: url})
        save
        info "Camera added"
      end
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

    # Set wrap
    def set_wrap(wrap)
      @config.wrap = wrap.to_i
      save
      info "Wrap set to #{wrap} files"
    end

    # Set duration
    def set_duration(seconds)
      @config.duration = seconds.to_i
      save
      info "Duration set to #{seconds} seconds"
    end

    # Set threshold
    def set_threshold(level)
      @config.threshold = level.to_i
      save
      info "Threshold set to #{level} objects"
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
      save
    end
  end
end
