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
      flexmock(repo).should_receive(:git).and_return(
        "1234567|Wed, 8 Feb 2017 18:38:33 +0100\n7654321|Thu, 9 Feb 2017 18:38:33 +0100"
      )
      commits = repo.changes_to_file('file')
      assert 2, commits.count

      assert '1234567', commits[0].short_hash
      assert 'Wed, 8 Feb 2017 18:38:33 +0100', commits[0].date.rfc2822

      assert 'n7654321', commits[1].short_hash
      assert 'Thu, 9 Feb 2017 18:38:33 +0100', commits[1].date.rfc2822
    end
  end
end
