# frozen_string_literal: true

RSpec.describe Gistory::LockfileParser do
  subject(:parser) { described_class.new(lockfile_content: lockfile_content) }

  describe '#gem_version' do
    let(:lockfile_path) { File.join(File.dirname(__FILE__), "../test_files/#{lockfile}") }
    let(:lockfile_content) { File.read(lockfile_path) }
    let(:lockfile) { 'Gemfile.lock' }

    it "parses the gem's version" do
      expect(parser.gem_version('actionmailer')).to eq('5.2.2')
    end

    context 'when the Gemfile has merge conflicts' do
      let(:lockfile) { 'Gemfile_with_merge_conflicts.lock' }

      it "parses the gem's version" do
        expect(parser.gem_version('twitter')).to eq('5.11.0')
      end
    end
  end
end
