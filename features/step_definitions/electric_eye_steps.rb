require 'construct'
require 'fileutils'

Then(/^it should create a pid file in "([^"]*)"$/) do |file|
  expect(File.exist?(file)).to equal(true)
end
