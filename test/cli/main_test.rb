# frozen_string_literal: true
require 'test_helper'

module Gistory
  module Cli
    class ArgParserTest < Minitest::Test
      def test_history
        skip('temporary skip')
        args = []
        cli = Gistory::Cli::Main.new(repo_path: '/', args: args)
        cli.run
      end

      def test_raises_if_no_changes_to_gem
        skip('temporary skip')
        args = []
        cli = Gistory::Cli::Main.new(repo_path: '/', args: args)
        assert_raises Gistory::Error do
          cli.run
        end
      end
    end
  end
end
