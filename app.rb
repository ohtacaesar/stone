# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__) + '/lib'
require 'sinatra'
require 'stone'

# sinatra用にオーバーライド
module Stone
  class LineNumberReader
    def initialize(text)
      @text = text.split("\r\n")
      @line_number = 0
    end

    def read_line
      line = @text[@line_number]
      @line_number += 1
      return line
    end
  end
end


if development?
  require 'sinatra/reloader'
end

get '/' do
  erb :index
end

post '/result' do input = params[:text]
  reader = Stone::LineNumberReader.new(input)
  lexer  = Stone::Lexer.new(reader)
  parser = Stone::Parser.new(lexer)
  basic_env = Stone::BasicEnv.new
  result = Hash.new
  while lexer.peek(0) != Stone::Token.EOF
    tree = parser.parse
    if tree
      r = tree.eval(basic_env)
      result[tree] = r
    end
  end
  
  erb :result, :locals => {:inputs => reader.text, :result => result}
end

