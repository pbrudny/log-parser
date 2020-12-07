require 'pry'
require_relative '../lib/parse'

module LogParser
  class Display
    def initialize(file_path)
      @file_path = file_path
    end

    def parsed
      @parsed ||= Parse.new(@file_path).call
    end

    def total_views
      parsed
    end

    def uniq_views
      parsed.total_views
    end
  end
end