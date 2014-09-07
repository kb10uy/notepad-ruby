# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'

module Notepad
  class Module
    attr_accessor :name,:classes,:modules
    def initialize(name)
      @name=name
      @classes=[]
      @modules=[]
    end
  end
  
  class Class
    attr_accessor :name,:methods,:class_vars,:instance_vars,:properties
    def initialize(name)
      @name=name
      @methods=[]
      @class_vars=[]
      @instance_vars=[]
      @properties=[]
    end
  end
  
  class Method
    attr_accessor :name,:codes
    def initialize(name)
      @name=name
      @codes=[]
    end
  end
  
  class NativeClass
    attr_accessor :name,:library_name,:methods
    def initialize(name,lib)
      @name=name
      @library_name=lib
    end
  end
  
  class NativeMethod
    attr_accessor :name,:native_name
    def initialize(name,native)
      @name=name
      @native_name=native
    end
  end
  
  class Variable
    attr_accessor :name
    def initialize(name)
      @name=name
    end
  end
  
  class Value
    attr_accessor :name,:value
    def initialize(name)
      @name=name
      @value=0
    end
  end
  
  class Machine
    attr_accessor :modules,:classes,:methods,:variables
    def initialize
      @modules=[]
      @classes=[]
      @methods=[]
      @variables=[]
    end
  end
  
  class Statement
    attr_accessor :type
    def initialize
      @type=nil
    end
    
    def execute(scope)
      
    end
  end
  
  class ExpressionNode
    def initialize
    
    end
    def eval
    
    end
  end
end