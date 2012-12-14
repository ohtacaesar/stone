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
      Ast::NestedEnv.new(@env)
    end

    def to_string
      "<fun: " + hashCode() + ">"
    end
  end
end
