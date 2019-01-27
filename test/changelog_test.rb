# frozen_string_literal: true

require 'test_helper'

module Gistory
  class ChangeLogTest < Minitest::Test
    VersionStub = Struct.new(:version)

    def test_no_changes_to_lockfile_found
      repo = flexmock('repo').should_receive(:changes_to_file).and_return([]).mock
      changelog = ChangeLog.new(repo: repo)
      changes = changelog.changelog_for_gem('mygem')
      assert [], changes
    end

    def test_gem_not_found_in_lockfile
      commits = [
        Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')
      ]
      versions = [
        nil
      ]

      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock
      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(*versions)

      changes = changelog.changelog_for_gem('mygem')
      assert [], changes
    end

    def test_commit_adds_gem_to_existing_gemfile
      # tests single commit that introduces the gem to an existing Gemfile.lock
      commits = [
        Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')
      ]
      versions = [
        VersionStub.new('1.2.3'),
        nil
      ]

      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock
      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(*versions)

      changes = changelog.changelog_for_gem('mygem')

      assert '1234567', changes.first.short_hash
      assert DateTime.parse('Wed, 8 Feb 2017 18:38:33 +0100'), changes.first.date
      assert '1.2.3', changes.first.version
    end

    def test_commit_adds_gem_and_gemfile_at_the_same_time
      # tests single commit that introduces the gem and the Gemfile.lock at the same time
      commits = [
        Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')
      ]
      versions = [
        VersionStub.new('1.2.3')
      ]

      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock
      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(*versions)

      changes = changelog.changelog_for_gem('mygem')

      assert '1234567', changes.first.short_hash
      assert DateTime.parse('Wed, 8 Feb 2017 18:38:33 +0100'), changes.first.date
      assert '1.2.3', changes.first.version
    end

    def test_multiple_commits_and_first_commit_introduces_the_gem_to_the_gemfile
      commit_hashes_and_gem_versions = {
        'c9d4a19' => '5.0.5',
        '8198719' => '5.0.2',
        '0b03443' => '5.0.2',
        '453f316' => '5.0.1',
        'db1ecad' => '5.0.1',
        '7fa4a05' => '5.0.0',
        '29b6e67' => nil
      }
      commits = commit_hashes_and_gem_versions.keys.each_with_index.map do |hash, index|
        Commit.new(short_hash: hash, date: Time.now - (index * 60))
      end
      versions = commit_hashes_and_gem_versions.values.map { |v| VersionStub.new(v) }

      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock
      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(*versions)

      changes = changelog.changelog_for_gem('mygem')

      assert 4, changes.count

      assert '5.0.5', changes[0].version
      assert 'c9d4a19', changes[0].commit.short_hash

      assert '5.0.2', changes[1].version
      assert '0b03443', changes[1].commit.short_hash

      assert '5.0.1', changes[2].version
      assert 'db1ecad', changes[2].commit.short_hash

      assert '5.0.0', changes[3].version
      assert '7fa4a05', changes[3].commit.short_hash
    end

    def test_multiple_commits_and_first_commit_introduces_gem_and_gemfile
      commit_hashes_and_gem_versions = {
        'c9d4a19' => '5.0.5',
        '8198719' => '5.0.2',
        '0b03443' => '5.0.2',
        '453f316' => '5.0.1',
        'db1ecad' => '5.0.1',
        '7fa4a05' => '5.0.0',
        '29b6e67' => '4.9.9'
      }
      commits = commit_hashes_and_gem_versions.keys.each_with_index.map do |hash, index|
        Commit.new(short_hash: hash, date: Time.now - (index * 60))
      end
      versions = commit_hashes_and_gem_versions.values.map { |v| VersionStub.new(v) }

      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock
      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(*versions)

      changes = changelog.changelog_for_gem('mygem')

      assert 5, changes.count

      assert '5.0.5', changes[0].version
      assert 'c9d4a19', changes[0].commit.short_hash

      assert '5.0.2', changes[1].version
      assert '0b03443', changes[1].commit.short_hash

      assert '5.0.1', changes[2].version
      assert 'db1ecad', changes[2].commit.short_hash

      assert '5.0.0', changes[3].version
      assert '7fa4a05', changes[3].commit.short_hash

      assert '4.9.9', changes[4].version
      assert '29b6e67', changes[4].commit.short_hash
    end
  end
end
