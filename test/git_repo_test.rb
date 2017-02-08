# frozen_string_literal: true
require 'test_helper'

module Gistory
  class GitRepoTest < Minitest::Test
    def test_raises_if_not_git_repo
      assert_raises Gistory::Error do
        GitRepo.new(path: Dir.tmpdir)
      end
    end

    def test_changes_to_file
      flexmock(Dir).should_receive(:exist?).and_return(true)
      repo = GitRepo.new(path: '.')
      flexmock(repo).should_receive(:git).and_return('1234567|Wed, 8 Feb 2017 18:38:33 +0100')
      commits = repo.changes_to_file('file')
      assert_equal '1234567', commits.first.short_hash
      assert_equal 'Wed, 8 Feb 2017 18:38:33 +0100', commits.first.date.rfc2822
    end
  end
end
