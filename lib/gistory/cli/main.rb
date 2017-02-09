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
      rescue Gistory::ParserError => error
        @io.error error.message
        @io.puts parser
      rescue Gistory::Error => error
        @io.error error.message
      end

      private

      def history(repo, gem_name)
        changes = ChangeLog.new(repo: repo).changelog_for_gem(gem_name)

        if changes.empty?
          raise(Gistory::Error, "Gem '#{gem_name}' not found in lock file, maybe a typo?")
        end

        @io.puts "Gem: #{gem_name}"
        @io.puts "Current version: #{changes.first.version}"
        @io.puts ''

        @io.puts 'Change history:'
        changes.each do |change|
          @io.puts "#{change.version} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{change.short_hash})"
        end
      end
    end
  end
end
