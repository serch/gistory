# frozen_string_literal: true

RSpec.describe Gistory::GitRepo do
  describe '.new' do
    it 'raise if the provided path is not a git repository' do
      expect { described_class.new(path: Dir.tmpdir) }.to raise_error(Gistory::Error)
    end
  end

  describe '#changes_to_file' do
    it 'converts the git output to commit objects' do
      allow(Dir).to receive(:exist?).and_return(true)
      repo = described_class.new(path: '.')

      allow(repo).to receive(:git).and_return(
        "1234567|Thu, 9 Feb 2017 18:38:33 +0100\n7654321|Wed, 8 Feb 2017 18:38:33 +0100"
      )
      commits = repo.changes_to_file('file')

      expect(commits[0].short_hash).to eq('1234567')
      expect(commits[0].date.rfc2822).to eq('Thu, 9 Feb 2017 18:38:33 +0100')

      expect(commits[1].short_hash).to eq('7654321')
      expect(commits[1].date.rfc2822).to eq('Wed, 8 Feb 2017 18:38:33 +0100')
    end
  end
end
