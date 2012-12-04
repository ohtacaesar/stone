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
        self.child(1)
      end
      
      def then_block
        self.child(2)
      end
      
      def else_block
        self.num_children > 2 ? child(3) : nil
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

    class DefStmnt < AstList
      def initialize(children)
        super(children)
      end
      
      def name
        self.child(0).get_text
      end
      
      def parameters
        self.child(1)
      end
      
      def body
        self.child(2)
      end
      
      def to_string
        "(def " + self.name + " " + self.parameters + " " + self.body + ")"
      end
    end
  end
end
