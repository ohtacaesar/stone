$LOAD_PATH << File.dirname(__FILE__) + '/lib'
require 'sinatra'
require 'stone'

if development?
  require 'sinatra/reloader'
end

get '/' do
  erb :index
end

post '/result' do  text = params[:text]
  reader = Stone::LineNumberReader.new(text)
  lexer  = Stone::Lexer.new(reader)
  parser = Stone::Parser.new(lexer)
  basic_env = Stone::BasicEnv.new
  
  while lexer.peek(0) != Stone::Token.EOF
    # p lexer.peek(0)
    tree = parser.parser  puts tree  if tree    # p tree.class
    r = tree.eval(basic_env)
    # print "=>"
    # p r
    tree << r
  end
  
  erb :result, :locals => {:tokens => tokens, :tree => tree}
end

