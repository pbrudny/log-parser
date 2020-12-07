require 'pry'
require_relative '../lib/validate'

module LogParser
  class Parse
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      File.open(file_path, 'r').each do |line|

      end
    end

    private

    attr_reader :file_path

    def valid?(line)
      # /help_page/1 126.318.035.038
      Validate.new(line).call
    end
  end
end