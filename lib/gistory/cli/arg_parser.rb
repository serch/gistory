# frozen_string_literal: true

require "optparse"

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
        raise(Gistory::ParserError, "No gem specified") unless gem_name

        @config.gem_name = gem_name
      end

      def create_parser(config)
        parser = OptionParser.new
        parser.banner = "Usage: gistory <gem_name> [options]"

        add_options(parser, config)

        parser
      end

      def add_options(parser, config)
        parser.separator ""
        parser.separator "Options:"

        add_max_fetched_commits(parser, config)
        add_use_commits_from_all_branches(parser, config)
        add_output_commit_hashes_only(parser, config)
        add_help(parser)
        add_version(parser)
      end

      def add_max_fetched_commits(parser, config)
        default = config.max_fetched_commits
        description = "max number of commits to be fetched (default #{default})"
        parser.on("-m", "--max-fetched-commits [Integer]", Integer, description) do |m|
          raise(Gistory::ParserError, "argument --max-fetched-commits must be an integer") if m.nil?

          config.max_fetched_commits = m
        end
      end

      def add_use_commits_from_all_branches(parser, config)
        description = "use commits from all branches " \
                      "(by default it uses only commits made to the current branch)"
        parser.on("-a", "--all-branches", description) do |a|
          config.all_branches = a
        end
      end

      def add_output_commit_hashes_only(parser, config)
        option_switch = "--hashes-only"
        parser.on(option_switch,
                  "output commit hashes only so they can be piped",
                  "for example: gistory #{option_switch} sidekiq | xargs git show") do |ho|
          config.output_commit_hashes_only = ho
        end
      end

      def add_help(parser)
        parser.on_tail("-h", "--help", "Show this message") do
          @io.puts parser
          exit
        end
      end

      def add_version(parser)
        parser.on_tail("--version", "Show version") do
          @io.puts "gistory version #{Gistory::VERSION}"
          exit
        end
      end
    end
  end
end
