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

      def to_s
        "(if " + condition.to_s + " " + then_block.to_s + " else" + else_block.to_s + ")"
      end
    end

    class WhileStmnt < AstList
      def initialize(children)
        super(children)
      end

      def condition
        self.child(0)
      end

      def body
        self.child(1)
      end

      def to_s
        "(while " + condition.to_s + " " + body.to_s + ")"
      end
    end

    class DefStmnt < AstList
      def initialize(children)
        super(children)
      end

      def name
        self.child(0).name
      end

      def parameters
        self.child(1)
      end

      def body
        self.child(2)
      end

      def to_s
        "(def " + self.name + " " + self.parameters.to_s + " " + self.body.to_s + ")"
      end
    end
  end
end
