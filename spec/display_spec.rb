require_relative 'spec_helper'
require_relative '../lib/display'

describe LogParser::Display do
  context 'valid logs' do
    subject { LogParser::Display.new('spec/fixtures/basic.log') }

    describe '#total_views' do
      it 'webpages with most page views' do
        expect(subject.total_views)
          .to match('\/help_page/1 4 visits\n/home 3 visits\n')
      end
    end

    describe '#unique_views' do
      it 'webpages with most unique page views ordered' do
        expect(subject.uniq_views)
          .to match('\/help_page/1 4 unique views\n/home 2 unique views\n')
      end
    end
  end

  context 'when broken' do
    subject { LogParser::Display.new('spec/fixtures/broken.log') }

    describe '#total_views' do
      it 'webpages with most page views' do
        expect(subject.total_views)
          .to eq('Error: Wrong IP address in line: 1')
      end
    end

    describe '#unique_views' do
      it 'webpages with most unique page views ordered' do
        expect(subject.uniq_views)
          .to eq('Error: Wrong IP address in line: 1')
      end
    end
  end
end
