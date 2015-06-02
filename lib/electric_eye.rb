require "electric_eye/version"

module ElectricEye
  # Your code goes here...
  def foo
    return false
  end

  # Check the directory and if it doesn't exist create it.
  def self.check_dir
    dir = "#{ENV['HOME']}/.electric_eye"
    Dir.mkdir(dir) unless Dir.exist?(dir)
    dir
  end
end
