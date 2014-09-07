# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'

require './DataStructure'
require './lib/Builtin'

module Notepad  
  class Machine
    attr_accessor :modules,:classes,:methods,:variables,:script
    def initialize
      @modules=[]
      @classes=[]
      @env_classes={}
      @methods=[]
      @variables=[]
      @script=[]
    end
    
    def execute_script
      @script.each do |stmt|
        pp stmt
        case stmt
        when Array
          #できるだけlist_expr直書きはやめて
          puts "Warning : Expression list statement is deprecated. Please split."
        when Notepad::GlobalVariableDefinition
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::ClassVariableDefinition
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::InstanceVariableDefinition
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::LocalVariableDefinition
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::Identifer
          #puts "Not inplemented statement : #{stmt.class}"
          
        when Notepad::Literal
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::TreeLiteral
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::ArrayLiteral
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::RangeLiteral
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::BinaryOperatorExpression
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::Assignment
          puts "Not inplemented statement : #{stmt.class}" 
        when Notepad::UnaryExpression
          #puts "Not inplemented statement : #{stmt.class}"
        when Notepad::PostExpression
          puts "Not inplemented statement : #{stmt.class}" 
        else
          puts "知るかボケ"
        end
      end
    end
    
    def add_environment_class(cls,name)
      @env_classes[name]=cls.new
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