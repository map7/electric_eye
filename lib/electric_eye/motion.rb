require 'methadone'
require 'open4'
require 'fileutils'

module ElectricEye
  class Motion
    include Methadone::CLILogging

    # Detect if there is motion given the results
    #
    # path = the log file which is created by vlc with the movementdetect lines in.
    # threshold is how many objects are moving at once expressed by vlc.
    #
    def detect(path, threshold = 2)
      results = read_log(path)
      results.each {|line| return true if movement(line) >= threshold}
      return false
    end

    # Read in the log file and return the motiondetect lines
    def read_log(path)
      results = []
      if File.exists?(path)
        File.readlines(path).each do |line|
          results.push line.chomp if line =~ /motiondetect filter/
        end
      end
      results
    end

    # Get the movement amount from the string
    def movement(line)
      line.slice!(/\[.*\]/)   # Remove the number in brackets at the start of the string
      line.slice(/\d+/).to_i  # Get the movement
    end
  end
end
