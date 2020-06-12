require_relative 'lib/parse'

report = CronParser::Parse.new(ARGV[0])
puts report.output