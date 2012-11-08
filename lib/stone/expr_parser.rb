# -*- coding: utf-8 -*-

module Stone
  class ExprParser
    class Precedence
      attr :value, :left_assoc
      def initialize(v, a)
        @value      = v
        @left_assoc = a
      end
    end

    attr :lexer, :operators

    def initialize(lexer)
      @lexer = lexer
      @operators = {}
      @operators["="]  = Precedence.new(0, true)
      @operators["<"]  = Precedence.new(1, true)
      @operators["<="] = Precedence.new(1, true)
      @operators[">"]  = Precedence.new(1, true)
      @operators[">="] = Precedence.new(1, true)
      @operators["=="] = Precedence.new(1, true)
      @operators["!="] = Precedence.new(1, true)
      @operators["+"]  = Precedence.new(2, true)
      @operators["-"]  = Precedence.new(2, true)
      @operators["*"]  = Precedence.new(3, true)
      @operators["/"]  = Precedence.new(3, true)
      @operators["^"]  = Precedence.new(4, false)
    end

    def do_shift(left, prec)
      op = Ast::AstLeaf.new(@lexer.read)
      right = factor
      while (n = next_operator) != nil && right_is_expr(prec, n)
        right = do_shift(right, n.value)
      end

      Ast::BinaryExpr.new([left, op, right])
    end

    def next_operator
      token = @lexer.peek(0)
      if token.is_identifier?
        @operators[token.get_text]
      else
        nil
      end
    end

    def right_is_expr(prec, next_prec)
      if next_prec.left_assoc
        prec < next_prec.value
      else
        prec <= next_prec.value
      end
    end

    def primary
      if is_token?("(")
        token("(")
        e = expr
        token(")")
        return e
      else
        token = @lexer.read
        if token.is_number?
          return Ast::NumberLiteral.new(token)
        elsif token.is_identifier?
          return Ast::IdentifierLiteral.new(token)
        elsif token.is_string?
          return Ast::StringLiteral.new(token)
        else
          raise "Parse Exception in primary"
        end
      end
    end

    def factor
      if is_token?("-")
        Ast::AstList.new([Ast::AstLeaf.new(@lexer.read), primary])
      else
        primary
      end
    end

    def expr
      right = factor
      while (n = next_operator) != nil
        right = do_shift(right, n.value)
      end
      right

      #left = factor
      #while is_token?("+") || is_token?("-") || is_token?("=") || is_token?("==")
      #  left = Ast::BinaryExpr.new([left, Ast::AstLeaf.new(@lexer.read), factor])
      #end
      #left
    end

    def block
      list = []
      token("{")
      list << statement unless is_eol?
      while ! is_token?("}")
        @lexer.read
        list << statement unless is_eol? || is_token?("}")
      end
      token("}")
      Ast::AstList.new(list)
    end

    def simple
      expr
    end

    def statement
      list = []
      if is_token?("if")
        list << Ast::AstLeaf.new(@lexer.read)
        list << expr
        list << block
        if is_token?("else")
          list << Ast::AstLeaf.new(@lexer.read)
          list << block
        end
      elsif is_token?("while")
        list << Ast::AstLeaf.new(@lexer.read)
        list << expr
        list << block
      else
        return simple
      end
      Ast::AstList.new(list)
    end

    def program
      s = statement unless is_eol?
      if is_eol?
        @lexer.read
      else
        raise "Parse Exception in program"
      end
      s
    end

    def token(name)
      token = @lexer.read
      unless token.is_identifier? && name == token.get_text
        raise "Parse Exception"
      end
    end

    def is_token?(name)
      token = @lexer.peek(0)
      token.is_identifier? && name == token.get_text
    end

    def is_eol?
      is_token?(";") || is_token?("\n")
    end
  end
end
