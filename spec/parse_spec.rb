require_relative 'spec_helper'
require_relative '../lib/display'

describe LogParser::Parse do
  context 'when empty file'do
    let(:file_path) { 'spec/fixtures/empty.log' }

    it do
      expect { LogParser::Parse.new(file_path).call }
        .to raise_error(LogParser::InvalidLogs)
    end
  end

  context 'when broken'do
    let(:file_path) { 'spec/fixtures/broken.log' }

    it do
      expect { LogParser::Parse.new(file_path).call }
        .to raise_error(LogParser::InvalidLogs)
    end
  end

  context 'when single line' do
    let(:results) { LogParser::Parse.new('spec/fixtures/single.log').call }
    let(:home_result) { results['/home'] }

    it { expect(home_result[:total]).to eq(1) }
    it { expect(home_result[:uniq]).to eq(1) }
    it { expect(home_result[:values]).to eq(['184.123.665.067']) }
  end

  context 'when few logs' do
    let(:results) { LogParser::Parse.new('spec/fixtures/basic.log').call }
    let(:home_result) { results['/home'] }
    let(:contact) { results['/contact'] }
    let(:about) { results['/about'] }
    let(:help_1) { results['/help_page/1'] }
    let(:help_2) { results['/help_page/2'] }

    describe 'total' do
      it { expect(home_result[:total]).to eq(3) }
      it { expect(contact[:total]).to eq(2) }
      it { expect(about[:total]).to eq(1) }
      it { expect(help_1[:total]).to eq(4) }
    end

    describe 'uniq' do
      it { expect(home_result[:uniq]).to eq(2) }
      it { expect(contact[:uniq]).to eq(1) }
      it { expect(about[:uniq]).to eq(1) }
      it { expect(help_1[:uniq]).to eq(4) }
    end
  end
end
