module ElectricEye
  class ConfigEye
    # Check the directory and if it doesn't exist create it.
    def self.check_dir
      Dir.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
    end

    # Save the config file
    def self.save(config)
      File.open(CONFIG_FILE, 'w'){ |f| f.write config.to_yaml } # Store
    end
  end
end
