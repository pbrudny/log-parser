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

    def parsed_keys
      @parsed_keys ||= parsed.keys
    end

    def total_views
      parsed.sort_by { |key, value| value[:total] }
        # .map { |result| "#{result[:total]}"}
    end

    def uniq_views
      parsed.sort_by { |key, value| value[:uniq] }
    end
  end
end