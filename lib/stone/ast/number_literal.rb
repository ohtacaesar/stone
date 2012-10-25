# -*- coding: utf-8 -*-

module Stone
  module Ast
    class NumberLiteral < AstLeaf
      def initialize(token)
        super(token)
      end

      def name
        self.token.get_text
      end
    end
  end
end
