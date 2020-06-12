require_relative 'test_helper'
require_relative '../lib/parse'

describe CronParser::Parse do
  def parse(expression, command = '/usr/bin/find')
    CronParser::Parse.new("#{expression} #{command}")
  end

  describe 'when initialized with valid cron expression' do
    describe 'sample expression' do
      before { @result = parse('*/15 0 1,15 * 1-5') }

      it { _(@result.minute_result).must_equal('0 15 30 45') }
      it { _(@result.hour_result).must_equal('0') }
      it { _(@result.day_of_month_result).must_equal('1 15') }
      it { _(@result.month_result).must_equal('1 2 3 4 5 6 7 8 9 10 11 12') }
      it { _(@result.day_of_week_result).must_equal('1 2 3 4 5') }
      it { _(@result.command_result).must_equal('/usr/bin/find') }
      it { _(@result.output).must_match(/minute        0 15 30 45\nhour          0\nday of month  1 15\nmonth         1 2 3 4 5 6 7 8 9 10 11 12\nday of week   1 2 3 4 5\ncommand       \/usr\/bin\/find/) }
    end

    # describe 'every minute' do
    #   before { @result = parse('* * ? * *') }
    #
    #   it { _(@result.minute_result).must_equal('0 15 30 45') }
    #   it { _(@result.hour_result).must_equal('0') }
    #   it { _(@result.day_of_month_result).must_equal('1 15') }
    #   it { _(@result.month_result).must_equal('1 2 3 4 5 6 7 8 9 10 11 12') }
    #   it { _(@result.day_of_week_result).must_equal('1 2 3 4 5') }
    #   it { _(@result.command_result).must_equal('/usr/bin/find') }
    # end

    # describe 'every even minute' do
    #   before { @result = parse('*/2 * ? * *') }
    #
    #   it { _(@result.minute_result).must_equal('0 15 30 45') }
    #   it { _(@result.hour_result).must_equal('0') }
    #   it { _(@result.day_of_month_result).must_equal('1 15') }
    #   it { _(@result.month_result).must_equal('1 2 3 4 5 6 7 8 9 10 11 12') }
    #   it { _(@result.day_of_week_result).must_equal('1 2 3 4 5') }
    #   it { _(@result.command_result).must_equal('/usr/bin/find') }
    # end

    # describe 'every uneven minute' do
    #   before { @result = parse('1/2 * ? * *') }
    #
    #   it { _(@result.minute_result).must_equal('0 15 30 45') }
    #   it { _(@result.hour_result).must_equal('0') }
    #   it { _(@result.day_of_month_result).must_equal('1 15') }
    #   it { _(@result.month_result).must_equal('1 2 3 4 5 6 7 8 9 10 11 12') }
    #   it { _(@result.day_of_week_result).must_equal('1 2 3 4 5') }
    #   it { _(@result.command_result).must_equal('/usr/bin/find') }
    # end
  end

  describe 'when initialized with invalid cron expression' do
    describe 'empty string' do
      before { @result = parse('','') }

      it { _(@result.minute_result).must_equal('invalid') }
      it { _(@result.hour_result).must_equal('invalid') }
      it { _(@result.day_of_month_result).must_equal('invalid') }
      it { _(@result.month_result).must_equal('invalid') }
      it { _(@result.day_of_week_result).must_equal('invalid') }
      it { _(@result.command_result).must_equal('invalid') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end

    describe 'too many arguments' do
      before { @result = parse('* * * ? * *') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end

    describe 'not enough arguments' do
      before { @result = parse('* * * ?') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end

    describe 'both week and month days' do
      before { @result = parse('* * * * *') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end

    describe 'not allowed numeric values' do
      before { @result = parse('0 24 * * ?') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end

    describe 'not allowed special characters' do
      before { @result = parse('0 23 * * _') }
      it { _(@result.output).must_match(/invalid cron expression/) }
    end
  end
end