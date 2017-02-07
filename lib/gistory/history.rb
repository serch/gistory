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

      puts "Gem: #{gem_name}"
      lockfile = Bundler::LockfileParser.new(Bundler.read_file('Gemfile.lock'))
      the_gem  = lockfile.specs.find { |s| s.name == gem_name }
      puts "Current version: #{the_gem.version}"
      puts ''

      puts 'Change history:'
      previous_version = nil
      commits = `git log --pretty=format:"%H|%cD" --max-count=100 --follow Gemfile.lock`
      commits.split("\n").each do |c|
        commit, date = c.split('|')
        file_content = `git show #{commit}:Gemfile.lock`
        lockfile = Bundler::LockfileParser.new(file_content)
        the_gem = lockfile.specs.find { |s| s.name == gem_name }

        # we got to the end, the gem didnt exist back then
        # what if it was added then removed and then added again???
        if the_gem.nil?
          puts 'the end'
          break
        end

        if previous_version.nil?
          # first commit
          previous_version = the_gem.version.to_s
          puts "#{the_gem.version} on #{date} (commit #{commit[0..6]})"
        elsif the_gem.version.to_s != previous_version # only print it if it changed
          previous_version = the_gem.version.to_s
          puts "#{the_gem.version} on #{date} (commit #{commit[0..6]})"
        end
      end
    end
  end
end
