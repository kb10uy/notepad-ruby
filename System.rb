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
      @value=nil
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
  
  class ValueOperator
    def initialize(target)
      @target=val
    end
    def binary_operate(op,right)
      return nil
    end
    
    def unary_operate(op)
    
    end
    
    def post_operate(op)
    
    end
    
    def call_method(name,args)
      return nil
    end
    
    def get_indexer
      return nil
    end
    
    def set_indexer(value)
      
    end
  end
  
  class MethodArguments
    attr_accessor :args
    def initialize
      @args=[]
    end
  end
end