require 'optparse'
require 'ostruct'

module Gistory
  class History
    def initialize(repo:, args:)
      @repo = repo
      @args = args
    end

    def run
      options = parse(@args)
      history(options.gem_name)
    rescue Gistory::Error => error
      puts error.message
    end

    def parse(args)
      options = OpenStruct.new
      options.max_lockfile_changes = 100

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: gistory <gem_name> [options]'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-m', '--max-lockfile-changes [INTEGER]', Integer, 'max number of changes to the lock file (default 100)') do |m|
          options.max_lockfile_changes = m
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          puts Gistory::VERSION
          exit
        end
      end

      opt_parser.parse!(args)
      gem_name = args.pop
      raise 'no gem name specified' unless gem_name
      options.gem_name = gem_name
      options
    end

    def history(gem_name)
      raise(Gistory::Error, 'No gem name provided') if gem_name.nil?
      puts "Gem: #{gem_name}"

      changes = ChangeLog.new(repo: @repo).changelog_for_gem(gem_name)
      puts "Current version: #{changes.first.version}"
      puts ''

      puts 'Change history:'
      changes.each do |change|
        puts "#{change.version} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{change.short_hash})"
      end
    end
  end
end
