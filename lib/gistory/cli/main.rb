module Gistory
  module Cli
    class Main
      def initialize(repo_path:, args:)
        @repo_path = repo_path
        @args = args
      end

      def run
        repo = GitRepo.new(path: @repo_path)
        config = Cli::ArgParser.new(args: @args).parse
        history(repo, config.gem_name)
      rescue Gistory::Error => error
        puts error.message
      end

      def history(repo, gem_name)
        changes = ChangeLog.new(repo: repo).changelog_for_gem(gem_name)

        if changes.empty?
          puts "Gem #{gem_name} not found in lock file, maybe a typo?"
          exit
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
