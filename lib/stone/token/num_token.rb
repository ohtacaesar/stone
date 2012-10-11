# -*- coding: utf-8 -*-
module Stone
  class NumToken < Token
    attr :value

    def initialize(line_number, value)
      super(line_number)
      @value = value
    end

    def is_number
      true
    end

    def get_text
      @value + ""
    end

    def get_number
      @value
    end
  end
end
