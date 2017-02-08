require 'optparse'

module Gistory
  class ArgParser
    def initialize(args:)
      @args = args
    end

    def parse!
      config = Gistory.config

      parser = create_parser(config)
      parser.parse!(@args)

      gem_name = @args.shift
      raise 'no gem name specified' unless gem_name
      config.gem_name = gem_name
      config
    rescue OptionParser::InvalidOption
      puts parser
      exit
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

      parser.on('-m', '--max-lockfile-changes [INTEGER]', Integer, 'max number of changes to the lock file (default 100)') do |m|
        config.max_lockfile_changes = m
      end
    end

    def add_common_options(parser)
      parser.separator ''
      parser.separator 'Common options:'

      parser.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

      parser.on_tail('--version', 'Show version') do
        puts Gistory::VERSION
        exit
      end
    end
  end
end
