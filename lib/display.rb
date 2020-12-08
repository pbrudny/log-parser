# frozen_string_literal: true

require_relative '../lib/parse'

module LogParser
  class Display
    def initialize(file_path)
      @file_path = file_path
    end

    def total_views
      display(:total, 'visit')
    end

    def uniq_views
      display(:uniq, 'unique view')
    end

    private

    def pluralize(base_word, number)
      number == 1 ? base_word : base_word + 's'
    end

    def display(field, label)
      parsed
        .sort_by { |_, value| -value[field] }
        .map { |x| "#{x[0]} #{x[1][field]} " + pluralize(label, x[1][field]) }
        .join("\n")
    rescue LogParser::InvalidLogs => e
      "Error: #{e.message}"
    end

    def parsed
      @parsed ||= Parse.new(@file_path).call
    end
  end
end
