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
      @patterns[:id]      = /(\s*)([ぁ-ん_ァ-ヴ_一-龠ー]+|[A-Z_a-z][A-Z_a-z0-9]*|,|;|\(|\)|{|}|==|>|<|<=|>=|&&|\|\||=|\+|-|\*|\/)/
    end

    def set_reader(reader)
      @reader = reader
    end

    def read
      if fill_queue(0)
        @queue.shift
      else
        Stone::Token.EOF
      end
    end

    def peek(i)
      if fill_queue(i)
        @queue[i]
      else
        Stone::Token.EOF
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

      string_scanner = StringScanner.new(line)
      match_flag = true
      while string_scanner.rest?
        # patternのいずれにもマッチしないでeach文が終わるとmatch_flagがfalseのままなので
        # エラーを発生させる
        raise "Error not much, #{string_scanner.inspect}" unless match_flag
        match_flag = false
        @patterns.each do |key, value|
          if item = string_scanner.scan(value)
            item.strip!
            # line_numberの初期値は1（0だけど、read_lineした時点で+1されるから）
            add_token(@reader.line_number, item, key)
            match_flag = true
            break
          end
        end
      end
      # 一番最後にEOFを追加
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
      when :comment
        # コメントは読み飛ばすから何もしない
      else
        raise "undefined patterns[:key]"
      end
      @queue << token if token
    end
  end
end
