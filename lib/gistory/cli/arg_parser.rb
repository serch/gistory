# frozen_string_literal: true
require 'optparse'

module Gistory
  module Cli
    class ArgParser
      def initialize(args:)
        @args = args
        @config = Gistory.config
        @parser = create_parser(@config)
      end

      def parse
        @parser.parse!(@args)

        parse_gem_name
        @config
      rescue OptionParser::InvalidOption => err
        raise(Gistory::ParserError, err.message)
      end

      def to_s
        @parser.to_s
      end

      private

      def parse_gem_name
        gem_name = @args.shift
        raise(Gistory::ParserError, 'No gem specified') unless gem_name
        @config.gem_name = gem_name
      end

      def create_parser(config)
        parser = OptionParser.new
        parser.banner = 'Usage: gistory <gem_name> [options]'

        add_specific_options(parser, config)
        add_common_options(parser)

        parser
      end

      def add_specific_options(parser, config)
        parser.separator ''
        parser.separator 'Specific options:'

        add_max_lockfile_changes(parser, config)
      end

      def add_common_options(parser)
        parser.separator ''
        parser.separator 'Common options:'

        add_help(parser)
        add_version(parser)
      end

      def add_max_lockfile_changes(parser, config)
        default = config.max_lockfile_changes
        description = "max number of changes to the lock file (default #{default})"
        parser.on('-m', '--max-lockfile-changes [INTEGER]', Integer, description) do |m|
          config.max_lockfile_changes = m
        end
      end

      def add_help(parser)
        parser.on_tail('-h', '--help', 'Show this message') do
          puts parser
          exit
        end
      end

      def add_version(parser)
        parser.on_tail('--version', 'Show version') do
          puts Gistory::VERSION
          exit
        end
      end
    end
  end
end
