# -*- coding: utf-8 -*-
module Stone
  class StrToken < Token
    attr :literal

    def initialize(line_number, literal)
      super(line_number)
      @literal = literal
    end

    def is_string?
      true
    end

    def get_text
      @literal
    end
  end
end
