module Gistory
  class ArgParser
    def initialize(args:)
      @args = args
    end

    def parse!
      options = OpenStruct.new
      options.max_lockfile_changes = 100

      opt_parser = parser(options)
      opt_parser.parse!(@args)

      gem_name = @args.pop
      raise 'no gem name specified' unless gem_name
      options.gem_name = gem_name
      options
    end

    def parser(options)
      opts = OptionParser.new
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

      opts
    end
  end
end
