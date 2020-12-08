# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/display'

describe LogParser::Validate do
  subject { LogParser::Validate }

  describe '#call' do
    context 'valid line with the main page' do
      it { expect(subject.new('/home 184.123.665.067', 3).call) }
    end

    context 'valid line with the sub page' do
      it { expect(subject.new('/help_page/1 126.318.035.038', 10).call) }
    end

    context 'invalid line' do
      it 'raises error for empty line' do
        expect { subject.new('', 4).call }
          .to raise_error(LogParser::InvalidLogs)
      end

      it 'raises error for wrong elements' do
        expect { subject.new('/help_page/1 126.318.035.038 hejka', 4).call }
          .to raise_error(LogParser::InvalidLogs)
      end

      it 'raises error for broken url' do
        expect { subject.new('\elp_page///1 126.318.035.038', 5).call }
          .to raise_error(
            LogParser::InvalidLogs,
            'Wrong url address in line: 5'
          )
      end

      it 'raises error for broken ip' do
        expect { subject.new('/help_page/1 126..038', 7).call }
          .to raise_error(LogParser::InvalidLogs, 'Wrong IP address in line: 7')
      end
    end
  end
end
