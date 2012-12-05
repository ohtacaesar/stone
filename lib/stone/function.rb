# -*- coding: utf-8 -*-
require 'ast/block_stmnt'
require 'ast/parameter_list'

module Stone
  class Function
    attr :parameters, :body

    @parameters = ParameterList.new
    @body = BlockStmnt.new
    @env = nil

    def initialize(params, body, env)
      @parameters = params
      @body = body
      @env = env
    end

    def make_env
      NestedEnv.new(@env)
    end

    def to_string
      "<fun: " + hashCode() + ">"
    end
  end
end
