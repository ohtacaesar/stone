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
        self.child(0).to_s
      end

      def then_block
        self.child(1).to_s
      end

      def else_block
        self.num_children > 2 ? child(2).to_s : "null"
      end

      def to_s
        "(if " + condition + " " + then_block + " else" + else_block + ")"
      end
    end

    class WhileStmnt < AstList
      def initialize(children)
        super(children)
      end

      def condition
        self.child(0).to_s
      end

      def body
        self.child(1).to_s
      end

      def to_s
        "(while " + condition + " " + body + ")"
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
        self.child(1).to_s
      end

      def body
        self.child(2).to_s
      end

      def to_s
        "(def " + self.name + " " + self.parameters + " " + self.body + ")"
      end
    end
  end
end
