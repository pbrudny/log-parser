# frozen_string_literal: true

module LogParser
  class InvalidLogs < StandardError; end

  class Validate
    def initialize(line, line_number)
      @line = line
      @line_number = line_number
      @url, @ip = line.split
    end

    def call
      valid_arguments? && valid_url? && valid_ip?
    end

    private

    attr_reader :line, :ip, :url, :line_number

    def valid_arguments?
      return true if line.split.count == 2

      raise InvalidLogs
    end

    def valid_url?
      return true if url&.match(%r{^[^\/]+\/[^\/].*$|^\/[^\/].*$})

      raise InvalidLogs, "Wrong url address in line: #{line_number}"
    end

    def valid_ip?
      return true if ip&.match(%r{^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$})

      raise InvalidLogs, "Wrong IP address in line: #{line_number}"
    end
  end
end
