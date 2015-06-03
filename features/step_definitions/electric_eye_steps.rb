require 'construct'
require 'fileutils'

Given(/^I have a camera called "([^"]*)"$/) do |arg1|
  @config = Construct.new
  @config.cameras = [{name: "Reception", url: "http://thecamera.org"}]
  dir="#{ENV['HOME']}/.electric_eye"
  FileUtils.rm_r(dir) if Dir.exist?(dir)
  Dir.mkdir(dir)
  File.open("#{dir}/config.yml","w"){ |f| f.write @config.to_yaml }
end

Then(/^we should have a directory called "([^"]*)"$/) do |dir|
  config_dir = File.expand_path(dir) # Expand ~ to ENV["HOME"]
  expect(Dir.exist?(config_dir)).to equal(true)
end

Then(/^we should have a file called "([^"]*)"$/) do |dir|
  config_file = File.expand_path(dir) # Expand ~ to ENV["HOME"]
  expect(File.exist?(config_file)).to equal(true)
end

Then(/^within the file "([^"]*)" we should have the camera "([^"]*)"$/) do |file, camera|
  config_file = File.expand_path(file) # Expand ~ to ENV["HOME"]
  @config = Construct.load File.read(config_file)
  expect(@config.cameras.length).to equal(1)
  expect(@config.cameras.first[:name] == camera).to equal(true)
end

Then(/^within the file "([^"]*)" we should no cameras$/) do |file|
  config_file = File.expand_path(file) # Expand ~ to ENV["HOME"]
  @config = Construct.load File.read(config_file)
  expect(@config.cameras.length).to equal(0)
end
