require "electric_eye/version"

module ElectricEye

  # Check the directory and if it doesn't exist create it.
  def check_dir
    dir = "#{ENV['HOME']}/.electric_eye"
    Dir.mkdir(dir) unless Dir.exist?(dir)
    dir
  end

  # Save the config file
  def save(file, config)
    File.open(file, 'w'){ |f| f.write config.to_yaml } # Store
  end
end
