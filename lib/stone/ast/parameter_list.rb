module Stone
  module Ast
    class ParameterList < AstList
      def initialize(children)
        super(children)
      end

      def name(i)
        self.child(i).get_text
      end

      def size
        self.num_children
      end
    end
  end
end
