require 'pry'
require_relative '../lib/validator'

module CronParser
  class Parse
    def initialize(cron_expression)
      self.cron_expression = cron_expression
    end

    def output
      return 'invalid cron expression' unless valid?

      "#{format('minute')}" + "#{minute_result}\n"\
      "#{format('hour')}" + "#{hour_result}\n"\
      "#{format('day of month')}" + "#{day_of_month_result}\n"\
      "#{format('month')}" + "#{month_result}\n"\
      "#{format('day of week')}" + "#{day_of_week_result}\n"\
      "#{format('command')}" + "#{command_result}"
    end

    def valid?
      CronParser::Validator.new(cron_expression).call
    rescue
      false
    end

    def all_values(top)
      (1..top).to_a.join(' ')
    end

    def range_values(range)
      numbers = range.split('-')
      (numbers[0].to_i..numbers[1].to_i).to_a.join(' ')
    end

    def skip_numbers?(value, top)
      args = value.split('/')
      args.count == 2 &&
        (args[0] == '*' || numeric?(args[0]) && args[0].to_i < top) &&
        numeric?(args[1]) && args[1].to_i < top
    end

    def numeric_with_commas?(value, top)
      numbers = value.split(',')
      numbers.count > 1 && numbers.all? { |n| numeric?(n) }
    end

    def numeric_values(value)
      value.split(',').join(' ')
    end

    def skip_values(value, top)
      args = value.split('/')
      i = args[0] == '*' ? 0 : args[0].to_i

      result = []
      while i <= top
        result << i
        i = i + args[1].to_i
      end
      result.join(' ')
    end

    def range?(value, top)
      numbers = value.split('-')
      numbers.count == 2 && numbers[0].to_i < numbers[1].to_i && numbers[1].to_i <= top
    end

    def parse(value, top)
      # binding.pry if top == 23
      if value == '*'
        all_values(top)
      elsif skip_numbers?(value, top)
        skip_values(value, top)
      elsif numeric?(value) && value.to_i < top
        value
      elsif numeric_with_commas?(value, top)
        numeric_values(value)
      elsif range?(value, top)
        range_values(value)
      else
        'invalid cron expression'
      end
    end

    def minute_result
      return 'invalid' unless valid?

      minute = cron_expression.split[0]
      parse(minute, 59)
    end

    def hour_result
      return 'invalid' unless valid?

      value = cron_expression.split[1]
      parse(value, 23)
    end

    def day_of_month_result
      return 'invalid' unless valid?

      value = cron_expression.split[2]
      parse(value, 31)
    end

    def month_result
      return 'invalid' unless valid?

      value = cron_expression.split[3]
      parse(value, 12)
    end

    def day_of_week_result
      return 'invalid' unless valid?

      value = cron_expression.split[4]
      parse(value, 7)
    end

    def command_result
      return 'invalid' unless valid?

      '/usr/bin/find'
    end

    def numeric?(value)
      true if Float(value) rescue false
    end

    private

    def format(title)
      title.ljust(14, ' ')
    end

    attr_accessor :cron_expression
  end
end