require 'construct'

Given(/^I have a camera called "([^"]*)"$/) do |arg1|
end

Then(/^we should have a directory called "([^"]*)"$/) do |dir|
  config_dir = File.expand_path(dir) # Expand ~ to ENV["HOME"]
  Dir.exist?(config_dir).should == true
end

Then(/^we should have a file called "([^"]*)"$/) do |dir|
  config_file = File.expand_path(dir) # Expand ~ to ENV["HOME"]
  File.exist?(config_file).should == true
end

Then(/^within the file "([^"]*)" we should have the camera "([^"]*)"$/) do |file, camera|
  config_file = File.expand_path(file) # Expand ~ to ENV["HOME"]
  @config = Construct.load File.read(config_file)
  @config.cameras.length.should == 1
  @config.cameras.first[:name].should == camera
end
