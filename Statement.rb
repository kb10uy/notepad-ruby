# -*- coding: utf-8 -*-
#The MIT License (MIT)
#Copyright (c) 2014 The Programming Language Notepad


require 'bundler/setup'
require 'parslet'

require './System'

module Notepad
  class Assignment < Notepad::ExpressionNode
    def initialize(left,op,right)
      @left=left
      @operator=op
      @right=right
    end
  end
  
  class UnaryExpression < Notepad::ExpressionNode
    def initialize(op,exp)
      @operator=op
      @expr=exp
    end
  end
  
  class PostExpression < Notepad::ExpressionNode
    def initialize(exp)
      @expr=exp
      @operations=[]
    end
    
    def add_operation(op)
      @operations.push op
    end
  end
  
  class PostOperation
    def initialize(bex)
      @base_expr=bex
    end
    
    def execute(exp,scope)
      
    end
  end
  
  class MethodCallOperation < Notepad::PostOperation
    def initialize(args)
      @args=args
    end
  end
  
  class IndexerOperation < Notepad::PostOperation
    def initialize(exp)
      @index_expr=exp
    end
  end
  
  class MemberAccessOperation < Notepad::PostOperation
    def initialize(name)
      @name=name
    end
  end
  
  class IncrementOperation < Notepad::PostOperation
    def initialize(op)
      @operator=op
    end
  end
  
  class BinaryOperatorExpression < Notepad::ExpressionNode
    def initialize(left)
      @left=left
      @rights=[]
    end
    
    def add_right(o,exp)
      @rights.push({:op=>o,:expr=>exp})
    end
    
    def eval(scope)
      
    end
  end
  
  class Identifer < Notepad::ExpressionNode
    def initialize(val)
      @value=val
    end
    
    def eval(scope)
      
    end
  end
  
  class Literal < Notepad::ExpressionNode
    def initialize(val)
      @value=val
    end
    
    def eval(scope)
      return @value
    end
  end
  
  class Tree < Notepad::ExpressionNode
    def initialize(thash)
      @hash_tree=thash
    end
    
    def eval(scope,cname)
      
    end
  end
  
  
  class Array < Notepad::ExpressionNode
    def initialize(tarr)
      @expr_list=tarr
    end
    
    def eval(scope,index)
    
    end
  end
  
  class Range < Notepad::ExpressionNode
    def initialize(sex,eex)
      @start_expr=sex
      @end_expr=eex
    end
  end
  ###############Value操作クラス
  
  
end