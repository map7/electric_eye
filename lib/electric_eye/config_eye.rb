module ElectricEye
  class ConfigEye
    # Check the directory and if it doesn't exist create it.
    def self.check_dir
      Dir.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
    end

    # Check that the config file exists.
    def self.check_config
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
    
  end
end
