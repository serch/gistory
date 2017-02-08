require 'optparse'
require 'ostruct'

module Gistory
  class ArgParser
    def initialize(args:)
      @args = args
    end

    def parse!
      config = Gistory.config

      opt_parser = parser(config)
      opt_parser.parse!(@args)

      gem_name = @args.pop
      raise 'no gem name specified' unless gem_name
      config.gem_name = gem_name
      config
    end

    def parser(config)
      opts = OptionParser.new
      opts.banner = 'Usage: gistory <gem_name> [options]'

      opts.separator ''
      opts.separator 'Specific options:'

      opts.on('-m', '--max-lockfile-changes [INTEGER]', Integer, 'max number of changes to the lock file (default 100)') do |m|
        config.max_lockfile_changes = m
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

      opts
    end
  end
end
