# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'

require './System'
require './Statement'

module Notepad
  class Lexer
    attr_accessor :machine
    
    def initialize(tree)
      @root=tree
      @machine=Notepad::Machine.new
    end
    
    def construct
      @root.each do |value|
        case value.keys[0]
        when :script
        when :module
          construct_module value[:module],@machine.modules
        when :class
          construct_class value[:class],@machine.classes
        when :method
          construct_method value[:method],@machine.method
        end
      end
    end
    
    def construct_module(node,root)
      md=Notepad::Module.new(node[:name][:identifer])
      node[:members].each do |value|
        case value[:member].keys[0]
        when :class
          construct_class value[:member][:class],md.classes
        when :module
          construct_mosule value[:member][:module],md.modules
        end
      end
      root.push md
    end
    
    def construct_class(node,root)
      cl=Notepad::Class.new(node[:name][:identifer])
      #TODO: extendの処理
      #TODO: implementの処理
      node[:members].each do |value|
        case value[:member].keys[0]
        when :instance_var
        when :class_var
        when :method
          construct_method value[:member][:method],cl.methods
        when :property
        end
      end
      
      root.push cl
    end
    
    def construct_method(node,root)
      mt=Notepad::Method.new(node[:name][:identifer])
      
      root.push mt
    end
    
  end
end