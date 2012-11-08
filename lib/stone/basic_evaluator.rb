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
    
    class BinaryExpr
      def eval(env)
        op = self.operator
        # javaのequalsはRubyの==と同じ. 値が等しいかどうかを調べる.
        if "=" == op
          right = self.right.eval(env)
          return comput_number(env, right)
        else
          left = self.left.eval(env)
          right = self.right.eval(env)
          return compute_op(left, op, right)
        end
      end

      def compute_op(left, op, right)
        if (left.kind_of?(Integer) and right.kind_of?(Integer))
          return compute_number(left.to_i, op, right.to_i)
        else
          if op == "+"
            return left.to_s + right.to_s
          elsif op == "*"
            return left.to_s * right.to_s
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
            if a == b then return TRUE else return FALSE end
          when ">"
            if a > b then return TRUE else return FALSE end
          when "<"
            if a < b then return TRUE else return FALSE end
          else
            # caseのelseはswitchのdefaultと一緒
            # 例外処理
        end
      end
    end
  end
end
