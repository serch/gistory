# frozen_string_literal: true

RSpec.describe Gistory::Cli::ArgParser do
  describe '#parse' do
    it 'parses the gem name' do
      parser = described_class.new(args: ['mygem'])
      config = parser.parse
      expect(config.gem_name).to eq('mygem')
    end

    it 'parses max_fetched_commits' do
      parser = described_class.new(args: ['mygem', '-m10'])
      config = parser.parse
      expect(config.gem_name).to eq('mygem')
      expect(config.max_fetched_commits).to eq(10)
    end

    it 'raises when no arguments are passed' do
      parser = described_class.new(args: [])
      expect { parser.parse }.to raise_error(Gistory::ParserError)
    end

    it 'raises when no gem name is passed' do
      parser = described_class.new(args: ['--max-fetched-commits', '10'])
      expect { parser.parse }.to raise_error(Gistory::ParserError)
    end

    it 'raises when invalid arguments are passed' do
      parser = described_class.new(args: ['mygem', '-m10', '-z1'])
      expect { parser.parse }.to raise_error(Gistory::ParserError)
    end

    it 'raises when max_fetched_commits is not an integer' do
      parser = described_class.new(args: ['mygem', '-mA'])
      expect { parser.parse }.to raise_error(Gistory::ParserError)
    end
  end
end
