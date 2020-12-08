# frozen_string_literal: true

require_relative '../lib/validate'

module LogParser
  class Parse
    def initialize(file_path)
      @file_path = file_path
      @results = {}
    end

    def call
      File.open(file_path, 'r').each_with_index do |line, index|
        break unless valid?(line, index + 1)

        url, ip = line.split
        add_ip(url, ip)
      end
      @results
    end

    private

    attr_reader :file_path, :results

    def valid?(line, line_number)
      Validate.new(line, line_number).call
    end

    def add_ip(url, ip)
      @results[url] = { total: 0, uniq: 0, values: [] } if @results[url].nil?

      exists = @results[url][:values].include?(ip)
      @results[url] = new_results(@results[url], ip, exists)
    end

    def new_results(result, ip, exists)
      {
        total: result[:total] + 1,
        uniq: exists ? result[:uniq] : result[:uniq] + 1,
        values: exists ? result[:values] : result[:values] << ip
      }
    end
  end
end
