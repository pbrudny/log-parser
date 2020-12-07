require_relative 'lib/display'

report = LogParser::Display.new(ARGV[0])
puts report.output