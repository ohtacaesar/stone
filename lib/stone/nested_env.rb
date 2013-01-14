# -*- coding: utf-8 -*-
# function.rbで利用
module Stone
  class NestedEnv    
    def initialize(outer = nil)
      @values = Hash.new
      @outer = outer
    end
    
    def put(name, value)
      env = where(name)
      env = self if env == nil
      @values.store(name, value)
    end
    
    def get(name)
      value = @values[name]
      if (value == nil and @outer != nil)
        @outer.get(name)
      else
        value
      end
    end

    def where(name)
      if @values.key?(name) != nil
        self
      elsif outer == nil
        nil
      else
        outer.where(name)
      end
    end 
  end
end
