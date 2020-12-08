# frozen_string_literal: true

require_relative 'lib/display'

report = LogParser::Display.new(ARGV[0])

puts '### Total visits ###'
puts report.total_views
puts "\n### Unique views ###"
puts report.uniq_views
