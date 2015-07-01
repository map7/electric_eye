require 'methadone'
require 'open4'
require 'fileutils'

module ElectricEye
  class Motion
    include Methadone::CLILogging

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

    # Detect if there is motion given the results
    def detect(results, threshold = 2)
      results.each do |line|
        line.slice!(/\[.*\]/)   # Remove the number in brackets at the start of the string
        movement = line.scan(/\d+/).first.to_i
        return true if movement >= threshold
      end
      return false
    end
  end
end
