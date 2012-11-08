# -*- coding: utf-8 -*-

module Stone
  module Ast
    class NumberLiteral < AstLeaf
      def initialize(token)
        super(token)
      end

      def value
        token.get_number
      end
    end

    class IdentifierLiteral < AstLeaf
      def initialize(token)
        super(token)
      end

      def name
        token.get_text
      end
    end

    class StringLiteral < AstLeaf
      def initialize(token)
        super(token)
      end

      def name
        token.get_text
      end
    end
  end
end
