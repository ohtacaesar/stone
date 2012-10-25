# -*- coding: utf-8 -*-

module Stone
  class ExprParser
    attr :lexer

    def initialize(lexer)
      @lexer = lexer
    end

    def expression
      left = term
      while is_token?("+") || is_token("-")
        op = Leaf.new(lexer.read)
        right = term
        left = BinaryExpr([left, op, right])
      end
      left
    end

    def term
      left = factor
      while is_token("*") || is_token("/")
        op = Leaf.new(lexer.read)
        right = factor
        left = BinaryExpr([lift, op ,right])
      end
    end

    def factor
      if is_token?("(")
        token("(")
        e = expression
        token(")")
        return e
      else
        t = lexer.read
        if t.is_number?
          n = NumberLiteral.new(t)
          return n
        else
          raise "Parser Exception"
        end
      end
    end

    def token(name)
      t = lexer.read
      unless t.is_indentifier? && name == t.get_text
        raise "Parser Exception"
      end
    end

    def is_token?(name)
      t = lexer.peek(0)
      return t.is_identifier? && name == t.get_text
    end
  end
end
