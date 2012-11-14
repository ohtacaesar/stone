# -*- coding: utf-8 -*-
module Stone
  module Ast
    class NullStmnt < AstList
      def initialize(children)
        super(children)
      end
    end
    
    class BlockStmnt < AstList
      def initialize(children)
        super(children)
      end
    end
    
    class IfStmnt < AstList
      def initialize(children)
        super(children)
      end
      
      def condition
        self.child(0)
      end
      
      def then_block
        self.child(1)
      end
      
      def else_block
        self.num_children > 2 ? child(2) : nil
      end
    end

    class WhileStmnt < AstList
      def initialize(children)
        super(children)
      end
      
      def condition
        self.child(1)
      end
      
      def body
        self.child(2)
      end
    end
  end
end
