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
