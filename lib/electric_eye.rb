require "electric_eye/version"
require "electric_eye/settings"
require "electric_eye/config_eye"

module ElectricEye
  def store_pids(pids = [])
    File.open("/tmp/electric_eye.pid", "w") { |file| file.write pids.join(" ") }
  end

  def record
    info "Cameras recording"
  end

  def record_path(path)
    path
  end
end
