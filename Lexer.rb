# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'

require './System'

module Notepad
  class Lexer
    def initialize(tree)
      @root=tree
    end
    
    def construct
      vm=Notepad::Machine.new
      for node in @root do
        p node.keys
      end
      return vm
    end
  end
end