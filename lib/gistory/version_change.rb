# frozen_string_literal: true

require "forwardable"

module Gistory
  class VersionChange
    extend Forwardable
    def_delegators :@commit, :short_hash, :date

    attr_reader :commit, :version

    def initialize(commit:, version:)
      @commit = commit
      @version = version
      freeze
    end

    def to_s
      "Version #{version} (on #{date} by #{short_hash})"
    end
  end
end
