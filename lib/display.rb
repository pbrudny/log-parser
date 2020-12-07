require 'pry'
require_relative '../lib/parse'

module LogParser
  class Display
    def initialize(file_path)
      @file_path = file_path
    end
  end
end