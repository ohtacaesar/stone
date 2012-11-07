# -*- coding: utf-8 -*-

module Stone
  class ExprParser
    attr :lexer

    def initialize(lexer)
      @lexer = lexer
    end

    def expression
      tree_left = term
      while is_token?("+") || is_token?("-")
        op = Ast::AstLeaf.new(@lexer.read)
        tree_right = term
        tree_left = Ast::BinaryExpr.new([tree_left, op, tree_right])
      end
      tree_left
    end

    def term
      tree_left = factor
        while is_token?("*") || is_token?("/")
        op = Ast::AstLeaf.new(@lexer.read)
        tree_right = factor
        tree_left = Ast::BinaryExpr.new([tree_left, op, tree_right])
      end
      tree_left
    end

    def factor
      if is_token?("(")
        token("(")
        e = expression
        token(")")
        return e
      else
        t = @lexer.read
        if t.is_number?
          n = Ast::NumberLiteral.new(t)
          return n
        else
          raise "Parser Exception"
        end
      end
    end

    def token(name)
      token = @lexer.read
      unless token.is_indentifier? && name == token.get_text
        raise "Parser Exception"
      end
    end

    def is_token?(name)
      token = @lexer.peek(0)
      token.is_identifier? && name == token.get_text
    end
  end
end
