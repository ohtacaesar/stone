# -*- coding: utf-8 -*-
module Stone
  class Function
    attr :parameters, :body

    def initialize(params, body, env)
      @parameters = params
      @body = body
      @env = env
    end

    def make_env
      NestedEnv.new(@env)
    end

    def to_s
      return "<function: #{@body} >"
    end
  end

  class NativeFunction
    attr :num_of_params
    def initialize(n, m)
      @name = n
      @method = m
      @num_of_params = m.parameters.length
    end
    
    def to_s
      return "<native: " + @name + ">"
    end

    def call(args, tree)
      # argsは配列（basic_evaluator.rb, 227行目付近）
      begin
        return @method.call(args)
      rescue
        raise "bad native function call: #{@method}"
      end
    end
  end
end
