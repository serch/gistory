require 'bundler'

module Gistory
  class History
    def initialize(repo:, args:)
      @repo = repo
      @args = args
    end

    def run
      history(@args.shift)
    rescue Gistory::Error => error
      puts error.message
    end

    def history(gem_name)
      raise(Gistory::Error, 'No gem name provided') if gem_name.nil?

      lockfile = Bundler::LockfileParser.new(Bundler.read_file('Gemfile.lock'))
      the_gem  = lockfile.specs.find { |s| s.name == gem_name }
      puts "current #{the_gem.version}"
      current = the_gem.version.to_s

      commits = `git log --pretty=format:"%H|%cD" --max-count=100 --follow Gemfile.lock`
      commits.split("\n").each do |c|
        commit, date = c.split('|')
        file_content = `git show #{commit}:Gemfile.lock`
        lockfile = Bundler::LockfileParser.new(file_content)
        the_gem = lockfile.specs.find { |s| s.name == gem_name }

        if the_gem.nil?
          puts 'the end'
          break
        elsif the_gem.version.to_s != current # only print it if it changed
          current = the_gem.version.to_s
          puts "#{the_gem.version} on #{date} (commit #{commit})"
        end
      end
    end
  end
end
