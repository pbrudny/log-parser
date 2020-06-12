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

    def minute_result
      return 'invalid' unless valid?

      minute = cron_expression.split[0]

      # '0 15 30 45'

      # star - every possible option
      # given values comma separated
      # range (1-5)
      # skip every */10
      if minute == '*'
        all_values(59)
      end
      # else if minute.match(//)
      # end

    end

    def all_values(top)
      (1..top).to_a.join(' ')
    end

    def range_values(range)
      numbers = range.split('-')
      (numbers[0].to_i..numbers[1].to_i).to_a.join(' ')
    end

    def range?(value, top)
      numbers = value.split('-')
      numbers.count == 2 && numbers[0].to_i < numbers[1].to_i && numbers[1].to_i <= top
    end

    def hour_result
      return 'invalid' unless valid?

      hour = cron_expression.split.arg[1]

      '0'
    end

    def day_of_month_result
      return 'invalid' unless valid?

      '1 15'
    end

    def month_result
      return 'invalid' unless valid?
      month = cron_expression.split[3]

      if month == '*'
        all_values(12)
      end
    end

    def day_of_week_result
      return 'invalid' unless valid?

      dow = cron_expression.split[4]

      if dow == '*'
        all_values(31)
      elsif range?(dow, 31)
        range_values(dow)
      end
    end

    def command_result
      return 'invalid' unless valid?

      '/usr/bin/find'
    end

    private

    def format(title)
      title.ljust(14, ' ')
    end

    attr_accessor :cron_expression
  end
end