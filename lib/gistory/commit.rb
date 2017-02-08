module Gistory
  class Commit
    attr_reader :short_hash, :date

    def initialize(short_hash:, date:)
      @short_hash = short_hash
      @date = date
      freeze
    end
  end
end
