# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'
require 'pp'

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
          construct_method value[:method],@machine.methods
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
      if @expr==nil then 
        @expr=[
          :identifer,:string,:number,:true,:false,:nil,:tree,:array,:range,
          :list_expr,:assign,:expr_unary,:expr_post,:expr_bin
        ]
      end
      mt=Notepad::Method.new(node[:name][:identifer])
      node[:block].each do |value|
        case value[:statement].keys[0]
        #式
        when *@expr
          t= construct_expression value[:statement]
          puts "###############################"
          pp t
          puts "###############################"
          
        #変数
        when :local_var
        when :class_var
        when :instance_var
        when :global_var
        #制御構文
        when :start_if
        when :start_for
        when :start_while
        when :start_unless
        when :desc
        when :start_switch
        end
      end
      root.push mt
    end
    
    def construct_expression(node)
      case node.keys[0]
      when :identifer
        return Notepad::Identifer.new(node[:identifer])
      when :string
        return Notepad::Literal.new(eval("\""+node[:string]+"\""))
      when :number
        return Notepad::Literal.new(eval(node[:number]))
      when :true
        return Notepad::Literal.new(true)
      when :false
        return Notepad::Literal.new(false)
      when :nil
        return Notepad::Literal.new(nil)
      when :tree
        ret={}
        if node[:tree][:pairs].instance_of?(Hash) then
          ret[node[:tree][:pairs][:pair][:key][:identifer]]= construct_expression node[:tree][:pairs][:pair][:value]
        else
          node[:tree][:pairs].each do |cpa|
            ret[cpa[:pair][:key][:identifer]] = construct_expression cpa[:pair][:value]
          end
        end
        return Notepad::Tree.new(ret)
      when :array
        ret=[]
        rno=node[:array][:list]
        if rno.has_key?(:list_expr) then
          rno[:list_expr].each do |vex|
            ret.push construct_expression vex
          end
        else
          ret.push construct_expression rno
        end
        return Notepad::Array.new(ret)
      when :range
        st=construct_expression node[:range][:start]
        en=construct_expression node[:range][:end]
        return Notepad::Range.new(st,en)
      when :expr_bin
        rno=node[:expr_bin]
        ret=Notepad::BinaryOperatorExpression.new(construct_expression(rno[0][:left]))
        for r in 1...(rno.length) do
          ret.add_right rno[r].keys[0],construct_expression(rno[r][:right])
        end
        return ret
      when :list_expr
        ret=[]
        node[:list_expr].each do |cexp|
          ret.push construct_expression cexp
        end
        return ret
      when :assign
        l=construct_expression node[:assign].values[0]
        r=construct_expression node[:assign].values[2]
        op=node[:assign].keys[1]
        return Notepad::Assignment.new(l,op,r)
      when :expr_unary
        op=node[:expr_unary].keys[0]
        ex=construct_expression node[:expr_unary][:right]
        return Notepad::UnaryExpression.new(op,ex)
      when :expr_post
        ex=construct_expression node[:expr_post][:left]
        ret=Notepad::PostExpression.new(ex)
        node[:expr_post][:posts].each do |po|
          case po.keys[0]
          when :method_call
            lopargs=[]
            if po[:method_call].instance_of?(Array) then
              po[:method_call].each do |argv|
                lopargs.push construct_expression(argv[:value])
              end
            else
              lopargs.push construct_expression(po[:method_call][:value])
            end
            lop=Notepad::MethodCallOperation.new(lopargs)
          when :indexer
            lop=Notepad::IndexerOperation.new(construct_expression(po[:indexer]))
          when :member_access
            lop=Notepad::MemberAccessOperation.new(po[:member_access][:identifer])
          when :later_increment,:later_decrement
            lop=Notepad::IncrementOperation.new(po.keys[0])
          end
          ret.add_operation lop
        end
        return ret
      end
    end
  end
end