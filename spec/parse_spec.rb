require_relative 'spec_helper'
require_relative '../lib/display'

describe LogParser::Parse do
  xdescribe 'webpages with most page views ordered from most pages views to less page views' do
    subject do
      LogParser::Parse.new('fixtures/webserver.log').page_views
    end

    it '' do
      expect(subject).to eq('/home 90 visits /index 80 visits')
    end
  end

  describe 'webpages with most unique page views ordered' do
    it '' do

    end
  end
end
