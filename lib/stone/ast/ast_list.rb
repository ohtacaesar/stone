# -*- coding: utf-8 -*-

module Stone
  module Ast
    class AstList < AstTree
      attr_reader :children

      def initialize(children)
        @children = children
      end

      def child(i)
        @children[i]
      end

      def to_s
        result = "("
        sep = ""
        @children.each do |child|
          result = result + sep + child.to_s
          sep = " "
        end
        result = result + ")"
      end

      def location
        @children.each do |child|
          if location = child.location
            return location
          end
        end
        nil
      end
    end
  end
end
