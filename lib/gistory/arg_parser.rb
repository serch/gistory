require 'optparse'

module Gistory
  class ArgParser
    def initialize(args:)
      @args = args
    end

    def parse
      config = Gistory.config

      parser = create_parser(config)
      parser.parse!(@args)

      parse_gem_name(parser, config)
      config
    rescue OptionParser::InvalidOption
      error_and_exit('Invalid option', parser)
    end

    def error_and_exit(msg, parser)
      puts msg
      puts ''
      puts parser
      exit
    end

    def parse_gem_name(parser, config)
      gem_name = @args.shift
      error_and_exit('No gem specified', parser) unless gem_name
      config.gem_name = gem_name
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

      default = config.max_lockfile_changes
      parser.on('-m', '--max-lockfile-changes [INTEGER]', Integer, "max number of changes to the lock file (default #{default})") do |m|
        config.max_lockfile_changes = m
      end
    end

    def add_common_options(parser)
      parser.separator ''
      parser.separator 'Common options:'

      parser.on_tail('-h', '--help', 'Show this message') do
        puts parser
        exit
      end

      parser.on_tail('--version', 'Show version') do
        puts Gistory::VERSION
        exit
      end
    end
  end
end
