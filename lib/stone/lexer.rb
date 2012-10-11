# -*- coding: utf-8 -*-
module Stone
  class Lexer

    def initialize(reader)
      @queue    = Array.new
      @has_more = true
      @reader   = reader

      @comment_pattern = /\/\/.*/
      @num_pattern     = /\d+/
      @string_pattern  = /"(\"|\\|\n|[^"])*\"/
      @id_pattern      = /[A-Z_a-z][A-Z_a-z0-9]*|\+|-|\*|\/|==|<=|>=|&&|\|\||\p{Punct}/
      # @pattern         = Regexp.union(
      #                              @comment_pattern,
      #                              @num_pattern,
      #                              @string_pattern,
      #                              @id_pattern
      #                              )
      @pattern = /(\/\/)|([\d]+)|("(\"|\\|\n|[^\"])*\")|([A-Z_a-z][A-Z_a-z0-9]*|\+|\*\/|==|<=|<|>=|>)/
      puts @pattern
    end

    def read
      if self.fill_queue(0)
        @queue.shift
      else
        Token.EOF
      end
    end

    def peek(i)
      if self.fill_queue(i)
        @queue[i]
      else
        Token.EOF
      end
    end

    def fill_queue(i)
      while i >= @queue.size
        if @has_more
          self.readline
        else
          return false
        end
      end
      return true
    end

    def readline
      line = @reader.read_line
      if line == nil
        @has_more = false
        return
      end
      line.scan(@pattern).each do |item|
        self.add_token(@reader.line_number, item)
      end
      @queue.push(IdToken.new(@reader.line_number, Token.EOL))
    end

    def add_token(line_number, match_data)
      unless match_data[0] #comment
        if match_data[1] #number
          token = NumToken.new(line_number, match_data[1].to_i)
          @queue.push(token)
        elsif match_data[2] #string
          token = StrToken.new(line_number, self.to_string_literal(match_data[2]))
          @queue.push(token)
        elsif match_data[3] # identifier
          token = IdToken.new(line_number, match_data[3])
          @queue.push(token)
        end
      end
    end

    def to_string_literal(string)
      result = ""
      len = string.size + 1
      i = 0
      while i < len
        c = string[i]
        if c == '\\' && i + 1 < len
          c2 = string[i + 1]
          if c2 == '"' || c2 == '\\'
            i += 1
            c = string[i]
          elsif c2 == 'n'
            i += 1
            c = '\n';
          end
        end
        result += c
      end
      result
    end
  end
end
