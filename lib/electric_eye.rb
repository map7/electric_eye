require "electric_eye/version"
require "electric_eye/settings"

module ElectricEye

  # Check the directory and if it doesn't exist create it.
  def check_dir
    Dir.mkdir(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
  end

  # Save the config file
  def save(config)
    File.open(CONFIG_FILE, 'w'){ |f| f.write config.to_yaml } # Store
  end
end
