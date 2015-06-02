require ('electric_eye.rb')

# Change the default path of home
@original_home = ENV['HOME']
ENV['HOME'] = "/tmp/fakehome"
FileUtils.rm_rf "/tmp/fakehome"
FileUtils.mkdir "/tmp/fakehome"
