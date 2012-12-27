# -*- coding: utf-8 -*-

require 'stone/ast/postfix'
require 'stone/ast/arguments'
require 'stone/ast/parameter_list'

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
      @operators["は"] = Precedence.new(0, true)
      @operators["<"]  = Precedence.new(1, true)
      @operators["<="] = Precedence.new(1, true)
      @operators[">"]  = Precedence.new(1, true)
      @operators[">="] = Precedence.new(1, true)
      @operators["=="] = Precedence.new(1, true)
      @operators["!="] = Precedence.new(1, true)
      @operators["イコール"] = Precedence.new(1, true)
      @operators["+"]     = Precedence.new(2, true)
      @operators["足す"]  = Precedence.new(2, true)
      @operators["-"]     = Precedence.new(2, true)
      @operators["引く"]  = Precedence.new(2, true)
      @operators["*"]     = Precedence.new(3, true)
      @operators["かける"]= Precedence.new(3, true)
      @operators["/"]     = Precedence.new(3, true)
      @operators["割る"]  = Precedence.new(3, true)
      @operators["^"]     = Precedence.new(4, false)
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
      array = []
      array << param
      while is_token?(",")
        token(",")
        array << param
      end
      Ast::ParameterList.new(array)
    end

    def param_list
      raise "Parser Error in param_list" unless is_token?("(")
      token("(")
      list = params
      token(")")
      list
    end

    def function
      array = []
      token("def")
      t = @lexer.read
      if t.is_identifier?
        Ast::DefStmnt.new([Ast::IdentifierLiteral.new(t), param_list, block])
      else
        raise "Parse Error in def"
      end
    end

    # このままじゃ引数なし関数でエラーでるよ！
    def args
      array = []
      array << expr
      while is_token?(",")
        token(",")
        array << expr
      end
      Ast::Arguments.new(array)
    end

    def postfix
      if is_token?("(")
        token("(")
        result = args unless is_token?(")")
        token(")")        
      elsif is_token?("[")
        token("[")
        array = Array.new
        array << expr
        result = Ast::ArrayRef.new(array)
        token("]")
      else
        raise "Parse Error in postfix"
      end
      result
    end
    
    def elements
      array = Array.new
      array << primary
      while is_token?(",")
        token(",")
        array << primary
      end
      Ast::ArrayLiteral.new(array)
    end

    def primary
      array = Array.new
      if is_token?("[")
        token("[")
        array << elements
        token("]")
      elsif is_token?("(")
        token("(")
        array << expr
        token(")")
      else
        t = @lexer.read
        if t.is_number?
          array << Ast::NumberLiteral.new(t)
        elsif t.is_identifier?
          array << Ast::IdentifierLiteral.new(t)
        elsif t.is_string?
          array << Ast::StringLiteral.new(t)
        else
          raise "Parse Exception in primary"
        end
      end
      while is_token?("(") || is_token?("[")
        array << postfix
      end
      Ast::PrimaryExpr.new(array)
    end

    def factor
      if is_token?("-")
        token("-")
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
      array = []
      token("{")
      while ! is_token?("}")
        while is_eol?
          @lexer.read
        end
        array << statement unless is_token?("}")
      end
      token("}")

      Ast::BlockStmnt.new(array)
    end

    def block_japanese
      array = []
      token("ならば")
      while ! is_token?("だ")
        while is_eol?
          @lexer.read
        end
        array << statement unless is_token?("だ")
      end
      token("だ")

      Ast::BlockStmnt.new(array)
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
      if is_token?("if")
        @lexer.read
        array = [expr, block]
        while is_eol?
          @lexer.read
        end
        if is_token?("else")
          token("else")
          array << block
        end
        Ast::IfStmnt.new(array)
      elsif is_token?("もし")
        @lexer.read
        array = [expr, block_japanese]
        while is_eol?
          @lexer.read
        end
        if is_token?("または")
          @lexer.read
          array << block_japanese
        end
        Ast::IfStmnt.new(array)
      elsif is_token?("while")
        token("while")
        Ast::WhileStmnt.new([expr, block])
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
      elsif is_eof?
        return result
      else
        t = @lexer.peek(0)
        raise "Parse Exception in parse: #{t}"
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

    def is_eof?
      @lexer.peek(0) == Stone::Token.EOF
    end

  end
end
