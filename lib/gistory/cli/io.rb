# frozen_string_literal: true

require "colorize"

module Gistory
  module Cli
    class Io
      def initialize(out: $stdout, err: $stderr)
        @out = out
        @err = err
      end

      def puts(msg)
        @out.puts(msg)
      end

      def error(msg)
        @err.puts(msg.red)
      end
    end
  end
end
