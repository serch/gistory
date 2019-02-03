# frozen_string_literal: true

RSpec.describe Gistory::ChangeLog do
  VersionStub = Struct.new(:version) do
    def nil?
      version.nil?
    end
  end

  describe '#changelog_for_gem' do
    let(:repo) { double('repo') }
    let(:gem_name) { 'mygem' }
    let(:subject) { described_class.new(repo: repo) }

    before do
      expect(repo).to receive(:changes_to_file).and_return(commits)
      allow(subject).to receive(:gem_spec_at_commit_hash).and_return(*versions)
    end

    context 'when no changes to the lockfile are found' do
      let(:commits) { [] }
      let(:versions) { ['dummy'] } # dummy otherwise and_return(*[]) fails

      it 'returns no version changes' do
        changes = subject.changelog_for_gem(gem_name)
        expect(changes).to be_empty
      end
    end

    context 'when the gem is not found in the lockfile' do
      let(:commits) { [Gistory::Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')] }
      let(:versions) { [nil] }

      it 'returns no version changes' do
        changes = subject.changelog_for_gem(gem_name)
        expect(changes).to be_empty
      end
    end

    context 'when there is only one commit that added the gem to an already existing lockfile' do
      let(:commits) { [Gistory::Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')] }
      let(:versions) { [VersionStub.new('1.2.3'), nil] }

      it 'returns one version change' do
        changes = subject.changelog_for_gem(gem_name)
        expect(changes.count).to eq(1)

        version_change = changes.first

        expect(version_change.short_hash).to eq('1234567')
        expect(version_change.date).to eq(DateTime.parse('Wed, 8 Feb 2017 18:38:33 +0100'))
        expect(version_change.version).to eq('1.2.3')
      end
    end

    context 'when there is only one commit that added the gem and the lockfile at the same time' do
      let(:commits) { [Gistory::Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')] }
      let(:versions) { [VersionStub.new('1.2.3')] }

      it 'returns one version change' do
        changes = subject.changelog_for_gem(gem_name)
        expect(changes.count).to eq(1)

        version_change = changes.first

        expect(version_change.short_hash).to eq('1234567')
        expect(version_change.date).to eq(DateTime.parse('Wed, 8 Feb 2017 18:38:33 +0100'))
        expect(version_change.version).to eq('1.2.3')
      end
    end

    context 'when there are multiple commits and the first one introduces the gem to the lockfile' do
      let(:commit_hashes_and_gem_versions) {
        {
          'c9d4a19' => '5.0.5',
          '8198719' => '5.0.2',
          '0b03443' => '5.0.2',
          '453f316' => '5.0.1',
          'db1ecad' => '5.0.1',
          '7fa4a05' => '5.0.0',
          '29b6e67' => nil
        }
      }
      let(:commits) {
        commit_hashes_and_gem_versions.keys.each_with_index.map do |hash, index|
          Gistory::Commit.new(short_hash: hash, date: Time.now - (index * 60))
        end
      }
      let(:versions) { commit_hashes_and_gem_versions.values.map { |v| VersionStub.new(v) } }

      it 'correctly returns all version changes' do
        changes = subject.changelog_for_gem(gem_name)

        expect(changes.count).to eq(4)

        expect(changes[0].short_hash).to eq('c9d4a19')
        expect(changes[0].version).to eq('5.0.5')

        expect(changes[1].short_hash).to eq('0b03443')
        expect(changes[1].version).to eq('5.0.2')

        expect(changes[2].short_hash).to eq('db1ecad')
        expect(changes[2].version).to eq('5.0.1')

        expect(changes[3].short_hash).to eq('7fa4a05')
        expect(changes[3].version).to eq('5.0.0')
      end
    end

    context 'when there are multiple commits and the first one introduces both the gem and the lockfile' do
      let(:commit_hashes_and_gem_versions) {
        {
          'c9d4a19' => '5.0.5',
          '8198719' => '5.0.2',
          '0b03443' => '5.0.2',
          '453f316' => '5.0.1',
          'db1ecad' => '5.0.1',
          '7fa4a05' => '5.0.0',
          '29b6e67' => '4.9.9'
        }
      }
      let(:commits) {
        commit_hashes_and_gem_versions.keys.each_with_index.map do |hash, index|
          Gistory::Commit.new(short_hash: hash, date: Time.now - (index * 60))
        end
      }
      let(:versions) { commit_hashes_and_gem_versions.values.map { |v| VersionStub.new(v) } }

      it 'correctly returns all version changes' do
        changes = subject.changelog_for_gem(gem_name)
        expect(changes.count).to eq(5)

        expect(changes[0].short_hash).to eq('c9d4a19')
        expect(changes[0].version).to eq('5.0.5')

        expect(changes[1].short_hash).to eq('0b03443')
        expect(changes[1].version).to eq('5.0.2')

        expect(changes[2].short_hash).to eq('db1ecad')
        expect(changes[2].version).to eq('5.0.1')

        expect(changes[3].short_hash).to eq('7fa4a05')
        expect(changes[3].version).to eq('5.0.0')

        expect(changes[4].short_hash).to eq('29b6e67')
        expect(changes[4].version).to eq('4.9.9')
      end
    end
  end
end
