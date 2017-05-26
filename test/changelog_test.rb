# frozen_string_literal: true

require 'test_helper'

module Gistory
  class ChangeLogTest < Minitest::Test
    VersionStub = Struct.new(:version)

    def test_changelog_for_gem
      commits = [Commit.new(short_hash: '1234567', date: 'Wed, 8 Feb 2017 18:38:33 +0100')]
      repo = flexmock('repo').should_receive(:changes_to_file).and_return(commits).mock

      changelog = ChangeLog.new(repo: repo)
      flexmock(changelog).should_receive(:gem_spec_at_commit_hash).and_return(VersionStub.new('1.2.3'), nil)

      changes = changelog.changelog_for_gem('mygem')

      assert_equal '1234567', changes.first.short_hash
      assert_equal DateTime.parse('Wed, 8 Feb 2017 18:38:33 +0100'), changes.first.date
      assert_equal '1.2.3', changes.first.version
    end
  end
end
