# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'

module Notepad
  class Module
    def new(name)
      @name=name
      @classes=[]
    end
  end
  
  class Class
    def new(name)
      @name=name
      @methods=[]
      @class_vars=[]
      @instance_vars[]
      @properties=[]
    end
  end
  
  class Method
    def new(name)
      @name=name
      @codes=[]
    end
  end
  
  class Variable
    def new(name)
      @name=name
    end
  end
  
  class Value
    def new(name)
      @name=name
    end
  end
  
  class Machine
    def new
      @modules=[]
      @classes=[]
      @methods=[]
      @variables=[]
    end
  end
end