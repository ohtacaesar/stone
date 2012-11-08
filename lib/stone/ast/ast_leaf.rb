# -*- coding: utf-8 -*-
require 'stone/tokens/token'

module Stone
  module Ast
    class AstLeaf < AstTree
      @@empty = []
      attr_reader :token

      def initialize(token)
        @token = token
      end

      def child(i)
        raise "IndexOutOfBoundsException"
      end

      def children
        @@empty
      end

      def to_s
        @token.get_text
      end

      def location
        "at line #{token.line_number}"
      end
    end
  end
end
