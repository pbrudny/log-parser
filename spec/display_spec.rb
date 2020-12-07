require_relative 'spec_helper'
require_relative '../lib/display'

describe LogParser::Display do
  subject do
    LogParser::Display.new('spec/fixtures/webserver.log')
  end

  describe '#total_views' do
    it 'webpages with most page views' do
      expect(subject.total_views).to match('\/home 90 visits \/index 80 visits')
    end
  end

  xdescribe '#unique_views' do
    it 'webpages with most unique page views ordered' do
      expect(subject.unique_views).to match(/about\/2 8 unique views/)
    end
  end
end
