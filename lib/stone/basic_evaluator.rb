# -*- coding: utf-8 -*-
module Stone
  module Ast
    TRUE = 1  
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
    
    class Name
      def eval(env)
        value = env.get(self.name)
      end
    end
    
    class NegativeExpr
      def eval(env)
        value = self.operand.eval(env)
        
        if value.is_a?(Integer)
          -(v.to_i)
        else
          raise 'bad type for - '
        end
      end
    end
  
    class BinaryExpr
      def eval(env)
        op = self.operator  
        # javaのequalsはRubyの==と同じ. 値が等しいかどうかを調べる.
        if "=" == op
          right = self.right.eval(env)
          return ComputeAssign.new(env, right)
        else
          left = self.left.eval(env)
          right = self.right.eval(env)
          return ComputeOp.new(left, op, right)
        end
      end
    end

    class ComputeAssign
      
      def initialize(env, rvalue)
        @list = self.left
      end
      
      if @list.is_a?(Name)
        env.put(@list.name, rvalue)
        return rvalue
      else
        # 例外処理
      end
    end
    
    class ComputeOp
      def initialize(left, op, right)
        if (left.is_a?(Integer) and right.is_a?(Integer))
          return ComputeNumber.new(left.to_i, op, right.to_i)
        else
          if op == "+"
            return left.to_s + right.to_s
          elsif op == "=="
            if left == nil
              if right == nil then TRUE else FALSE end
            else
              if left == right then TRUE else FALSE end
            end
          else
            # 例外処理
          end
        end
      end
    end
    
    class ComputeNumber
      def initialize(left, op, right)
        @left = left
        @op = op
        @right = right
      end
      a = @left.to_i
      b = @right.to_i
      
      case @op
        when "+" then a + b
        when "-" then a - b
        when "*" then a * b
        when "/" then a / b
        when "%" then a % b
        when "=="
          if a == b then TRUE else FALSE end
        when ">"
          if a > b then TRUE else FALSE end
        when "<"
          if a < b then TRUE else FALSE end
        else
          # caseのelseはswitchのdefaultと一緒
          # 例外処理
      end
    end
  end
end
