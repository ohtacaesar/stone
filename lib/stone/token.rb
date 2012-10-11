# -*- coding: utf-8 -*-
module Stone
  class Token
    attr_reader :line_number
    def initialize(line_number)
      @line_number = line_number
    end

    @@EOF = self.new(-1)
    @@EOL = "\\n"

    def self.EOF
      @@EOF
    end

    def self.EOL
      @@EOL
    end


    def is_identifier
      false
    end

    def is_number
      false
    end

    def is_string
      false
    end

    def get_number
      raise Exception, "not number"
    end

    def get_text
      ""
    end
  end
end

require 'stone/token/num_token'
require 'stone/token/str_token'
require 'stone/token/id_token'
