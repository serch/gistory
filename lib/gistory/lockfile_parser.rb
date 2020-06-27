# frozen_string_literal: true

require "bundler"

module Gistory
  class LockfileParser
    def initialize(lockfile_content:)
      @lockfile_content = lockfile_content
    end

    def gem_version(gem_name)
      lockfile = Bundler::LockfileParser.new(@lockfile_content)
      gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }
      gem_spec ? gem_spec.version.to_s : nil
    rescue Bundler::LockfileError => _e
      # bundler could not parse the lockfile
      # f.i. it could have been committed with merge conflicts
      # try to parse it with a regex
      # gem version looks like "    byebug (9.0.6)"
      # TODO: what if the gem was in the merge conflict?
      regexp = /\n\s{4}#{gem_name} \((?<version>.+)\)\n/
      matches = @lockfile_content.match(regexp)
      matches ? matches[:version] : nil
    end
  end
end
