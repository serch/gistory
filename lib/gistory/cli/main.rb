# frozen_string_literal: true
require 'colorize'

module Gistory
  module Cli
    class Main
      def initialize(repo_path:, args:)
        @repo_path = repo_path
        @args = args
      end

      def run
        repo = GitRepo.new(path: @repo_path)
        parser = Cli::ArgParser.new(args: @args)
        config = parser.parse
        history(repo, config.gem_name)
      rescue Gistory::ParserError => error
        puts error.message.red
        puts parser
      rescue Gistory::Error => error
        puts error.message.red
      end

      private

      def history(repo, gem_name)
        changes = ChangeLog.new(repo: repo).changelog_for_gem(gem_name)

        if changes.empty?
          raise(Gistory::Error, "Gem '#{gem_name}' not found in lock file, maybe a typo?")
        end

        puts "Gem: #{gem_name}"
        puts "Current version: #{changes.first.version}"
        puts ''

        puts 'Change history:'
        changes.each do |change|
          puts "#{change.version} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{change.short_hash})"
        end
      end
    end
  end
end
