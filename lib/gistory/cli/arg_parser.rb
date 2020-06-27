# frozen_string_literal: true

require 'optparse'

module Gistory
  module Cli
    class ArgParser
      def initialize(args:, io: Gistory::Cli::Io.new)
        @args = args
        @config = Gistory.config
        @parser = create_parser(@config)
        @io = io
      end

      def parse
        @parser.parse!(@args)

        parse_gem_name
        @io.error("extra parameters ignored: #{@args}") unless @args.count.zero?
        @config
      rescue OptionParser::InvalidOption => e
        raise(Gistory::ParserError, e.message)
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

        add_options(parser, config)

        parser
      end

      def add_options(parser, config)
        parser.separator ''
        parser.separator 'Options:'

        add_max_lockfile_changes(parser, config)
        add_use_commits_from_all_branches(parser, config)
        add_help(parser)
        add_version(parser)
      end

      def add_max_lockfile_changes(parser, config)
        default = config.max_lockfile_changes
        description = "max number of changes to the lock file (default #{default})"
        parser.on('-m', '--max-lockfile-changes [INTEGER]', Integer, description) do |m|
          raise(Gistory::ParserError, 'argument --max-lockfile-changes must be an integer') if m.nil?
          config.max_lockfile_changes = m
        end
      end

      def add_use_commits_from_all_branches(parser, config)
        description = 'use commits from all branches ' \
                      '(by default it uses only commits made to the current branch)'
        parser.on('-a', '--all-commits', description) do |a|
          config.all_commits = a
        end
      end

      def add_help(parser)
        parser.on_tail('-h', '--help', 'Show this message') do
          @io.puts parser
          exit
        end
      end

      def add_version(parser)
        parser.on_tail('--version', 'Show version') do
          @io.puts "gistory version #{Gistory::VERSION}"
          exit
        end
      end
    end
  end
end
