# -*- coding: utf-8 -*-

module Stone
  class Parser
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
      t = @lexer.peek(0)
      if t.is_identifier?
        @operators[t.get_text]
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

    def param
      t = @lexer.read
      if t.is_identifier?
        Ast::IdentifierLiteral.new(t)
      else
        raise "Parser Exception in param"
      end
    end

    def params
      list = []
      list << param
      while is_token?(",")
        token(",")
        list << param
      end
      Ast::AstList.new(list)
      # Ast::ParameterList.new(list)
    end

    def param_list
      raise "Parser Error in param_list" unless is_token?("(")
      token("(")
      list = params
      token(")")
      list
    end

    def function
      list = []
      token("def")
      t = @lexer.read
      if t.is_identifier?
        Ast::DefStmnt.new([Ast::IdentifierLiteral.new(t), param_list, block])
      else
        raise "Parse Error in def"
      end
    end

    def args
      list = []
      list << expr
      while is_token?(",")
        token(",")
        list << expr
      end
      Ast::AstList.new(list)
    end

    def postfix
      raise "Parse Error in postfix" unless is_token?("(")
      token("(")
      result = args unless is_token?(")")
      token(")")
      result
    end

    def primary
      e = nil
      if is_token?("(")
        token("(")
        e = expr
        token(")")
      else
        t = @lexer.read
        if t.is_number?
          e =  Ast::NumberLiteral.new(t)
        elsif t.is_identifier?
          e = Ast::IdentifierLiteral.new(t)
        elsif t.is_string?
          e = Ast::StringLiteral.new(t)
        else
          raise "Parse Exception in primary"
        end
      end

      list = []
      while is_token?("(")
        list << postfix
      end

      #if is_token?("(")
      #  right = postfix
      #  Ast::PrimaryExpr.new([left, right])
      #else
      #  Ast::PrimaryExpr.new([left])
      #end

      if list.length > 0
        e = Ast::AstList.new(list.unshift(e))
      end

      e
    end

    def factor
      if is_token?("-")
        op = Ast::AstLeaf.new(token("-")) # -を読み飛ばしているだけのような
        Ast::NegativeExpr.new([primary])
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

      Ast::BlockStmnt.new(list)
    end

    def simple
      e = expr
      if is_token?("-") || is_token?("(")
        Ast::AstList.new([e, args])
      else
        e
      end
    end

    def statement
      list = []
      if is_token?("if")
        list << Ast::AstLeaf.new(@lexer.read)
        list << expr
        list << block
        while is_token?("\n")
          @lexer.read
        end
        if is_token?("else")
          list << Ast::AstLeaf.new(@lexer.read)
          list << block
        end
        Ast::IfStmnt.new(list)
      elsif is_token?("while")
        list << Ast::AstLeaf.new(@lexer.read)
        list << expr
        list << block
        Ast::WhileStmnt.new(list)
      else
        return simple
      end
    end

    def parse
      result = nil
      unless is_eol?
        if is_token?("def")
          result = function
        else
          result = statement
        end
      end
      if is_eol?
        @lexer.read
      else
        raise "Parse Exception in parse"
      end
      return result
    end

    def token(name)
      t = @lexer.read
      unless t.is_identifier? && name == t.get_text
        raise "Parse Exception"
      end
    end

    def is_token?(name)
      t = @lexer.peek(0)
      t.is_identifier? && name == t.get_text
    end

    def is_eol?
      is_token?(";") || is_token?("\n")
    end
  end
end
