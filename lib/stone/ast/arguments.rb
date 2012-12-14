module Stone
  module Ast
    class Arguments < Postfix
      def initialize(children)
        super(children)
      end

      def size
        self.num_children
      end
    end
  end
end
