# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'

require './System'

module Notepad
  class AssignmentStatement < Notepad::Statement
    def initialize(left,op,right)
      @left=left
      @operator=op
      @right=right
    end
  end
  
  
end