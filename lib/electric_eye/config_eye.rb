require 'methadone'

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
      if File.exist?(CONFIG_FILE)
        Construct.load File.read(CONFIG_FILE)
      else
        Construct.new({cameras: []})
      end
    end

    # Save the config file
    def self.save(config)
      File.open(CONFIG_FILE, 'w'){ |f| f.write config.to_yaml } # Store
    end

    # Add camera
    def self.add_camera(camera, url)
      @config = load
      @config.cameras.push({name: camera, url: url})
      save(@config)
      info "Camera added"
      @config
    end

    def self.remove_camera(camera)
      @config = load
      record = @config.cameras.bsearch{ |c| c[:name] == camera }
      if record
        @config.cameras.delete(record)
        ConfigEye.save(@config)
      end
      info "Camera removed"
      @config
    end

    attr_reader :config
    def initialize
      @config = ConfigEye.load
    end
  end
end
