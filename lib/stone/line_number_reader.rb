# -*- coding: utf-8 -*-
module Stone
  class LineNumberReader
    attr :text
    attr_accessor :line_number

    def initialize(filename)
      File.open(filename) do |file|
        @text = file.readlines
      end
      @line_number = 0
    end

    def read_line
      line = @text[@line_number]
      @line_number += 1
      return line
    end

  end
end
