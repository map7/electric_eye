require 'construct'
require 'timecop'
require 'fakefs/spec_helpers'
require ('electric_eye.rb')

RSpec.configure do |config|
  config.before(:each) do
    # Set the directory
    stub_const("ElectricEye::CONFIG_DIR", "/tmp/fakehome/.electric_eye")
    stub_const("ElectricEye::CONFIG_FILE", "/tmp/fakehome/.electric_eye/config.yml")
  end
end
