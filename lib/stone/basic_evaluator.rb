# -*- coding: utf-8 -*-

module Stone
  module Ast
    TRUE  = 1
    FALSE = 0

    class AstTree
      def eval(env)
      end
    end

    class AstList
      def eval(env)
      end
    end

    class AstLeaf
      def eval(env)
      end
    end

    class NumberLiteral
      def eval(env)
        self.value
      end
    end

    class StringLiteral
      def eval(env)
        self.value
      end
    end

    class IdentifierLiteral
      def eval(env)
        value = env.get(self.name)

        if value == nil
          # 例外処理
        else
          value
        end
      end
    end

    class NegativeExpr
      def eval(env)
        value = operand().eval(env)
        if value.kind_of?(Integer)
          -value
        else
          # 例外処理
        end
      end
    end

    class BinaryExpr
      def eval(env)
        op = self.operator
        # javaのequalsはRubyの==と同じ. 値が等しいかどうかを調べる.
        if op == "="
          right = self.right.eval(env)
          return compute_assign(env, right)
        else
          left = self.left.eval(env)
          right = self.right.eval(env)
          return compute_op(left, op, right)
        end
      end

      def compute_assign(env, rvalue)
        l = self.left()
        # 教科書ではNameクラスだけどIdentifierLiteralクラスにしてる
        # ast/number_literal.rb
        if l.kind_of?(IdentifierLiteral)
          env.put(l.name, rvalue)
          rvalue
        else
          # 例外処理
        end
      end

      def compute_op(left, op, right)
        if (left.kind_of?(Integer) and right.kind_of?(Integer))
          return compute_number(left.to_i, op, right.to_i)
        else
          # 右辺か左辺が変数だった時？
        end
      end

      def compute_number(left, op, right)
        a = left
        b = right

        case op
          when "+" then return a + b
          when "-" then return a - b
          when "*" then return a * b
          when "/" then return a / b
          when "%" then return a % b
          when "=="
            # if a == b then return TRUE else return FALSE end
            a == b ? TRUE : FALSE 
          when ">"
            # if a > b then return TRUE else return FALSE end
            a > b ? TRUE : FALSE
          when "<"
            # if a < b then return TRUE else return FALSE end
            a < b ? TRUE : FALSE
          else
            # 例外処理
        end
      end
    end

    # なんか教科書だと5章でこんなのつくってる、から7章でこれのevalを追加しようとしてる。
    # class PrimaryExpr
    #   def eval
    #   end
    # end
    class BlockStmnt
      def eval(env)
        result = 0
        self.children.each do |tree|
          result = tree.eval(env)
        end
        result
      end
    end

    class IfStmnt
      def eval(env)
        condition = self.condition().eval(env)

        if condition == TRUE
          self.then_block().eval(env)
        else
          block = self.else_block()
          if block == nil
            0
          else
            block.eval(env)
          end
        end
      end
    end

    class WhileStmnt
      def eval(env)
        result = 0
        loop do
          condition = self.condition().eval(env)

          if condition == FALSE
            return result
          else
            result = self.body().eval(env)
          end
        end
      end
    end

    class DefStmnt
      def eval(env)
        f = Stone::Function.new(parameters, body, env)
        env.put(name, f)
        name
      end
    end

    class PostFix
      def eval(env, value)
      end
    end

    class ParameterList
      def eval(env, index, value)
        env.put(name(index), value)
      end
    end

  end
end
