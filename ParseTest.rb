#coding: utf-8

require './Parser'
require './Lexer'

str=File.read(ARGV[0],:encoding=>Encoding::UTF_8)
parsed=Notepad::Parser.new.parse(str)
lexer=Notepad::Lexer.new parsed

lexer.construct
