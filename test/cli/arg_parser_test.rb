# frozen_string_literal: true

require 'test_helper'

module Gistory
  module Cli
    class ArgParserTest < Minitest::Test
      def test_parse_gem_name
        parser = ArgParser.new(args: ['mygem'])
        config = parser.parse
        assert 'mygem', config.gem_name
      end

      def test_parse_max_lockfile_changes
        parser = ArgParser.new(args: ['mygem', '-m10'])
        config = parser.parse
        assert 'mygem', config.gem_name
        assert 10, config.max_lockfile_changes
      end

      def test_raises_no_args
        parser = ArgParser.new(args: [])
        assert_raises Gistory::ParserError do
          parser.parse
        end
      end

      def test_raises_no_gem
        parser = ArgParser.new(args: ['--max-lockfile-changes', '10'])
        assert_raises do
          parser.parse
        end
      end

      def test_raises_invalid_args
        parser = ArgParser.new(args: ['mygem', '-m10', '-z1'])
        assert_raises Gistory::ParserError do
          parser.parse
        end
      end

      def test_raises_max_lockfile_changes_non_integer
        parser = ArgParser.new(args: ['mygem', '-mA'])
        assert_raises Gistory::ParserError do
          parser.parse
        end
      end
    end
  end
end
