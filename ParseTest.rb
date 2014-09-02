#coding: utf-8

require './NotepadParser'

str=File.read(ARGV[0],:encoding=>Encoding::UTF_8)
parsed=NotepadParser.new.parse(str)
pp parsed
