# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad

require '../System'

module Notepad
  module Builtin
    class IO < Notepad::ValueOperator
      def call_method(name,args)
        puts args[0]
      end
    end
  end
end