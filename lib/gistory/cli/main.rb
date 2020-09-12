# frozen_string_literal: true

module Gistory
  module Cli
    class Main
      def initialize(repo_path:, args:, io: Gistory::Cli::Io.new)
        @repo_path = repo_path
        @args = args
        @io = io
      end

      def run
        repo = GitRepo.new(path: @repo_path)
        parser = Cli::ArgParser.new(args: @args, io: @io)
        config = parser.parse
        history(repo, config.gem_name)
      rescue Gistory::ParserError => e
        @io.error e.message
        @io.puts parser
      rescue Gistory::Error => e
        @io.error e.message
      end

      private

      def history(repo, gem_name)
        changes = ChangeLog.new(repo: repo).changelog_for_gem(gem_name)

        if changes.empty?
          raise(Gistory::Error, "Gem '#{gem_name}' not found in lock file, maybe a typo?")
        end

        if Gistory.config.output_commit_hashes_only?
          print_commit_hashes_only(changes)
        else
          print_full_output(gem_name, changes)
        end
      end

      def print_commit_hashes_only(changes)
        changes.each { |change| @io.puts change.short_hash }
      end

      def print_full_output(gem_name, changes)
        @io.puts "Gem: #{gem_name}"
        @io.puts "Current version: #{changes.first.version}"
        @io.puts ""

        print_change_history(changes)

        @io.puts ""

        print_configuration_info
      end

      def print_change_history(changes)
        @io.puts "Change history:"
        max_length = changes.map { |c| c.version.length }.max

        changes.each do |change|
          @io.puts "#{change.version.ljust(max_length)} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} " \
                   "(commit #{change.short_hash})"
        end
      end

      def print_configuration_info
        max = Gistory.config.max_fetched_commits
        if Gistory.config.all_branches?
          @io.puts "The last #{max} changes to the lock file were fetched."
        else
          @io.puts "The last #{max} commits made to the current branch were fetched."
        end

        @io.puts "To see farther in the past use the -m switch"
      end
    end
  end
end
