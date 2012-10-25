# -*- coding: utf-8 -*-
require 'strscan'

module Stone
  class Lexer
    def initialize(reader = nil)
      @queue    = Array.new
      @has_more = true
      @reader   = reader

      @patterns = Hash.new
      @patterns[:comment] = /(\s*)(\/\/.*)/
      @patterns[:number]  = /(\s*)([0-9]+)/
      @patterns[:string]  = /(\s*)("(\"|\\|\n|[^"])*\")/
      @patterns[:id]      = /(\s*)([A-Z_a-z][A-Z_a-z0-9]*|\(|\)|==|>|<|<=|>=|&&|\|\||=|\+|-|\*|\/)/
    end

    def set_reader(reader)
      @reader = reader
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
      line.chomp!
      # puts "\n\nline = '#{line}'"

      string_scanner = StringScanner.new(line)
      flag = true
      while string_scanner.rest?
        raise "Error not much" unless flag
        flag = false
        # マッチしないと無限ループに
        @patterns.each do |key, value|
          if item = string_scanner.scan(value)
            item.strip!
            # puts "line_number => #{@reader.line_number.to_s}, item => #{item}, key => #{key.to_s}"
            self.add_token(@reader.line_number, item, key)
            flag = true
            break
          end
        end
      end
      @queue << IdToken.new(@reader.line_number, Token.EOL)
    end

    def add_token(line_number, match_data, key)
      token = nil
      case key
      when :number
        token = NumToken.new(line_number, match_data.to_i)
      when :string
        token = StrToken.new(line_number, match_data)
      when :id
        token = IdToken.new(line_number, match_data)
      end
      @queue << token unless token == nil
    end
  end
end
