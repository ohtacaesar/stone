# -*- coding: utf-8 -*-
module Stone
  class IdToken < Token
    attr :text

    def initialize(line_number, id)
      super(line_number)
      @text = id
    end

    def is_identifier?
      true
    end

    def get_text
      @text
    end
  end
end
