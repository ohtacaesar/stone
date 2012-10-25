# -*- coding: utf-8 -*-

module Stone
  class OpPrecedenceParser

    class Precedence
      attr_reader :value, :left_assoc
      def initialize(value, left_assoc)
        @value = value
        @left_assoc = left_assoc
      end
    end

    attr :lexer, :oprators
    def initialize(lexer)
      @lexer = lexer
      @operators = {}
      @operators["<"] = Precedence.new(1, true)
      @operators[">"] = Precedence.new(1, true)
      @operators["+"] = Precedence.new(2, true)
      @operators["-"] = Precedence.new(2, true)
      @operators["*"] = Precedence.new(3, true)
      @operators["/"] = Precedence.new(3, true)
      @operators["^"] = Precedence.new(4, true)
    end

    def expression
      right = factor
      while (n = next_operator)
        right = do_shift(right, n.value)
      end
      right
    end

    def do_shift(left, prec)
      op = Ast::AstLeaf.new(@lexer.read)
      right = factor
      while (n = next_operator) && self.class.right_is_expr?(prec, n)
        right = do_shift(right, n.value)
      end
      Ast::BinaryExpr.new([left, op, right])
    end

    def next_operator
      token = lexer.peek(0)
      if token.is_identifier?
        @operators[token.get_text]
      else
        nil
      end
    end

    def self.right_is_expr?(prec, next_prec)
      if next_prec.left_assoc
        prec < next_prec.value
      else
        prec <= next_prec.value
      end
    end

    def factor
      if is_token?("(")
        token("(")
        e = expression
        token(")")
        e
      else
        token = lexer.read
        if token.is_number?
          Ast::NumberLiteral.new(token)
        else
          raise "Parse Exception"
        end
      end
    end

    def token(name)
      token = lexer.read
      unless token.is_identifier? && name == token.get_text
        raise "Parser Exception"
      end
    end

    def is_token?(name)
      token = lexer.peek(0)
      token.is_identifier? && name == token.get_text
    end
  end
end
