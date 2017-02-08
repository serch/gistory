# frozen_string_literal: true
module Gistory
  class Commit
    attr_reader :short_hash, :date

    def initialize(short_hash:, date:)
      @short_hash = short_hash
      @date = DateTime.parse(date.to_s)
      freeze
    end
  end
end
