require 'pry'
require_relative '../lib/validate'

module LogParser
  class Parse
    def initialize(file_path)
      @file_path = file_path
      @results = {}
    end

    def call
      File.open(file_path, 'r').each_with_index do |line, line_number|
        return unless valid?(line, line_number)

        url, ip = line.split
        add_ip(url, ip)
      end
      @results
    end

    def add_ip(url, ip)
      if @results[url].nil?
        @results[url] = { total: 1, uniq: 1, values: [ip] }
      else
        result = @results[url]
        exists = result[:values].include?(ip)

        @results[url] = {
          total: result[:total] + 1,
          uniq: exists ?  result[:uniq] : result[:uniq] + 1,
          values: exists ? result[:values] : result[:values] << ip
        }
      end
    end

    private

    attr_reader :file_path, :results

    def valid?(line, line_number)
      Validate.new(line, line_number).call
    end
  end
end