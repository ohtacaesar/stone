module Stone
  module Ast
    class ArrayRef < Postfix
      def initialize(children)
        super(children)
      end
      
      def index
        child(0)
      end
      
      def to_s
        "[" + index.to_s + "]"
      end
    end  
  end
end
