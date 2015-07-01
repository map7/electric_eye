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
          if line =~ /motiondetect filter/
            results.push line.chomp
          end
        end
      end
      results
      
    end
  end
end
