# -*- coding: utf-8 -*-

module Stone
  module Ast
    class BinaryExpr < AstList
      def initialize(array)
        super(array)
      end

      def left
        self.child(0)
      end

      def operator
        self.child(1).token.get_text
      end

      def right
        self.child(2)
      end
    end

    class NegativeExpr < AstList
      def initialize(array)
        super(array)
      end

      def operand
        self.child(0)
      end

      def to_s
        "-" + operand.to_s
      end
    end

    class PrimaryExpr < AstList
      def initialize(array)
        super(array)
      end

      def self.create(array)
        array.size == 1 ? array[0] : PrimaryExpr.new(array)
      end

    end
  end
end
